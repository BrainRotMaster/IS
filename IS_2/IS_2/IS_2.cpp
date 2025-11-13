#include <iostream>
#include <string>
#include <vector>
#include <queue>
#include <stack>
#include <unordered_map>
#include <algorithm>
#include <fstream>
#include <chrono>

using namespace std;
using namespace std::chrono;

class Puzzle15Solver {
private:
    const int SIZE = 4;
    const int TOTAL_CELLS = 16;
    const string GOAL = "123456789ABCDEF0";

    const vector<pair<int, int>> DIRECTIONS = { {-1, 0}, {0, 1}, {1, 0}, {0, -1} };//y:x
    const vector<char> DIR_NAMES = { 'U', 'R', 'D', 'L' };

    struct Node {
        string state;
        string path;
        int empty_pos;
        int g;
        int h;

        Node(string s, string p, int e)
            : state(s), path(p), empty_pos(e) {
        }
        Node(string s, string p, int e, int g_val, int h_val)
            : state(s), path(p), empty_pos(e), g(g_val), h(h_val) {
        }

        int f() const { return g + h; }

        bool operator>(const Node& other) const {
            return f() > other.f();
        }
    };

    int hexCharToInt(char c) {
        if (c >= '0' && c <= '9') return c - '0';
        if (c >= 'A' && c <= 'F') return 10 + (c - 'A');
        return -1;
    }

    vector<Node> getNeighbors(const Node& node) {
        vector<Node> neighbors;
        int empty_row = node.empty_pos / SIZE;
        int empty_col = node.empty_pos % SIZE;

        for (int i = 0; i < 4; i++) {
            int new_row = empty_row + DIRECTIONS[i].first;
            int new_col = empty_col + DIRECTIONS[i].second;

            if (new_row >= 0 && new_row < SIZE && new_col >= 0 && new_col < SIZE) {
                int new_pos = new_row * SIZE + new_col;
                string new_state = node.state;

                swap(new_state[node.empty_pos], new_state[new_pos]);

                neighbors.push_back(Node(new_state, node.path + DIR_NAMES[i], new_pos));
            }
        }

        return neighbors;
    }

    //  pos[i] = i.y, i.x
    vector<pair<int, int>> getGoalPositions() {
        vector<pair<int, int>> goal_pos(16);
        for (int i = 0; i < TOTAL_CELLS; i++) {
            char c = GOAL[i];
            int val = hexCharToInt(c);
            goal_pos[val] = { i / SIZE, i % SIZE };
        }
        return goal_pos;
    }

    int manhattanDistance(const string& state) {
        static const vector<pair<int, int>> goal_pos = getGoalPositions();
        int distance = 0;

        for (int i = 0; i < TOTAL_CELLS; i++) {
            char c = state[i];
            if (c == '0') continue;

            int val = hexCharToInt(c);
            int current_row = i / SIZE;
            int current_col = i % SIZE;
            int goal_row = goal_pos[val].first;
            int goal_col = goal_pos[val].second;

            distance += abs(current_row - goal_row) + abs(current_col - goal_col);
        }
        return distance;
    }

    int linearConflicts(const string& state) {
        int conflicts = 0;

        //  в строках
        for (int row = 0; row < SIZE; row++) {
            for (int i = 0; i < SIZE; i++) {
                char tile1 = state[row * SIZE + i];
                if (tile1 == '0') continue;
                int val1 = hexCharToInt(tile1);
                int goal_row1 = (val1 - 1) / SIZE;
                if (goal_row1 != row) continue;

                for (int j = i + 1; j < SIZE; j++) {
                    char tile2 = state[row * SIZE + j];
                    if (tile2 == '0') continue;
                    int val2 = hexCharToInt(tile2);
                    int goal_row2 = (val2 - 1) / SIZE;
                    if (goal_row2 != row) continue;

                    if (val1 > val2) {
                        conflicts += 2;
                    }
                }
            }
        }

        // в столбцах
        for (int col = 0; col < SIZE; col++) {
            for (int i = 0; i < SIZE; i++) {
                char tile1 = state[i * SIZE + col];
                if (tile1 == '0') continue;
                int val1 = hexCharToInt(tile1);
                int goal_col1 = (val1 - 1) % SIZE;
                if (goal_col1 != col) continue;

                for (int j = i + 1; j < SIZE; j++) {
                    char tile2 = state[j * SIZE + col];
                    if (tile2 == '0') continue;
                    int val2 = hexCharToInt(tile2);
                    int goal_col2 = (val2 - 1) % SIZE;
                    if (goal_col2 != col) continue;

                    if (val1 > val2) {
                        conflicts += 2;
                    }
                }
            }
        }

        return conflicts;
    }

    int cornerConflicts(const string& state) {
        int conflicts = 0;

        // Левый верхний угол (0,0)
        char top_left = state[0];
        if (top_left != '1' && top_left != '0') {
            char right = state[1]; 
            char down = state[4];  

            if (right == '2' && down == '5') {
                conflicts += 2;
            }
        }

        // Правый верхний угол (0,3)  
        char top_right = state[3];
        if (top_right != '4' && top_right != '0') {
            char left = state[2];  
            char down = state[7];  

            if (left == '3' && down == '8') {
                conflicts += 2;
            }
        }

        // Левый нижний угол (3,0)
        char bottom_left = state[12];
        if (bottom_left != 'D' && bottom_left != '0') { 
            char right = state[13];  
            char up = state[8];     

            if (right == 'E' && up == '9') { 
                conflicts += 2;
            }
        }

        return conflicts;
    }

    int combinedHeuristic(const string& state) {
        int manhattan = manhattanDistance(state);
        int linear = linearConflicts(state);
        int corner = cornerConflicts(state);
        return manhattan + linear + corner;
    }

public:

    bool isSolvable(const string& state) {
        int sumN = 0;
        int emptyRow = 0;

        for (int i = 0; i < TOTAL_CELLS; i++) {
            char currentChar = state[i];

            if (currentChar == '0') {
                emptyRow = i / SIZE + 1;
                continue;
            }

            int currentVal = hexCharToInt(currentChar);
            int n_i = 0;

            for (int j = i + 1; j < TOTAL_CELLS; j++) {
                char nextChar = state[j];
                if (nextChar == '0') continue;

                int nextVal = hexCharToInt(nextChar);
                if (nextVal < currentVal) {
                    n_i++;
                }
            }

            sumN += n_i;
        }

        int N = sumN + emptyRow;
        return (N % 2 == 0);
    }

    bool isValidInput(const string& input) {
        if (input.length() != TOTAL_CELLS) {
            cout << "ERROR need 16 symbols" << endl;
            return false;
        }

        vector<bool> found(TOTAL_CELLS, false);

        for (char c : input) {
            int val = hexCharToInt(c);
            if (val == -1) {
                cout << "ERROR not available symbol '" << c << "'." << endl;
                return false;
            }
            if (found[val]) {
                cout << "ERROR symbol '" << c << "' is not unique" << endl;
                return false;
            }
            found[val] = true;

        }

        for (int i = 0; i < TOTAL_CELLS; i++) {
            if (!found[i]) {
                cout << "ERROR miss symbol in input " << i << endl;
                return false;
            }
        }

        return true;
    }

    string solveBFS(const string& initial) {
        int empty_pos = initial.find('0');
        queue<Node> q;
        unordered_map<string, bool> visited;

        q.push(Node(initial, "", empty_pos));
        visited[initial] = true;

        int states_visited = 0;

        while (!q.empty()) {
            Node current = q.front();
            q.pop();
            states_visited++;

            if (current.state == GOAL) {
                cout << "BFS visited states: " << states_visited << endl;
                if (states_visited == 1) {
                    return "-";
                }
                return current.path;
            }

            vector<Node> neighbors = getNeighbors(current);
            for (const Node& neighbor : neighbors) {
                if (!visited[neighbor.state]) {
                    visited[neighbor.state] = true;
                    q.push(neighbor);
                }
            }
        }

        return "";
    }

    string solveDFS(const string& initial, int depth_limit, int& states_visited, bool printInfo = true) {
        int empty_pos = initial.find('0');
        stack<Node> s;
        unordered_map<string, int> visited; // храним глубину посещения

        s.push(Node(initial, "", empty_pos));
        visited[initial] = 0;
        states_visited = 0;

        while (!s.empty()) {
            Node current = s.top();
            s.pop();
            states_visited++;

            if (current.state == GOAL) {
                if (printInfo) {
                    cout << "DFS visited states: " << states_visited << endl;
                }
                if (states_visited == 1) {
                    return "-";
                }
                return current.path;
            }

            // Пропускаем если превысили глубину
            if (current.path.length() >= depth_limit) {
                continue;
            }

            vector<Node> neighbors = getNeighbors(current);
            for (const Node& neighbor : neighbors) {
                auto it = visited.find(neighbor.state);
                if (it == visited.end() || it->second > neighbor.path.length()) {
                    visited[neighbor.state] = neighbor.path.length();
                    s.push(neighbor);
                }
            }
        }

        return "";
    }

    string solveIDS(const string& initial) {
        int max_depth = 50;
        int total_states = 0;

        for (int depth = 1; depth <= max_depth; depth++) {
            int states_visited = 0;
            string result = solveDFS(initial, depth, states_visited, false);
            total_states += states_visited;

            if (!result.empty()) {
                cout << "IDS visited states: " << total_states << endl;
                return result;
            }

        }

        return "";
    }

    string solveAStar(const string& initial) {
        if (initial == GOAL) return "-";

        int empty_pos = initial.find('0');

        priority_queue<Node, vector<Node>, greater<Node>> open_set;
        unordered_map<string, int> best_g; // храним только лучший g для каждого состояния

        int h0 = combinedHeuristic(initial);
        open_set.push(Node(initial, "", empty_pos, 0, h0));
        best_g[initial] = 0;

        int states_visited = 0;

        while (!open_set.empty()) {
            Node current = open_set.top();
            open_set.pop();
            states_visited++;

            if (current.g > best_g[current.state]) {
                continue;
            }

            if (current.state == GOAL) {
                cout << "A* visited states: " << states_visited << endl;
                return current.path;
            }

            vector<Node> neighbors = getNeighbors(current);
            for (const Node& neighbor : neighbors) {
                int new_g = current.g + 1;
                auto it = best_g.find(neighbor.state);

                if (it == best_g.end() || new_g < it->second) {
                    best_g[neighbor.state] = new_g;
                    int new_h = combinedHeuristic(neighbor.state);
                    open_set.push(Node(neighbor.state, neighbor.path, neighbor.empty_pos, new_g, new_h));
                }
            }

            if (states_visited > 10000000) {
                cout << "A*: State limit reached" << endl;
                break;
            }
        }

        return "";
    }

    string solveIDAStar(const string& initial) {
        if (initial == GOAL) return "-";

        int stateLim = 10000000;
        int empty_pos = initial.find('0');
        int threshold = combinedHeuristic(initial);

        int total_states = 0;

        while (true) {
            unordered_map<string, int> visited;
            stack<Node> s;

            int h = combinedHeuristic(initial);
            s.push(Node(initial, "", empty_pos, 0, h));
            visited[initial] = 0;

            int states_visited = 0;
            int next_threshold = INT_MAX;

            while (!s.empty() && states_visited < stateLim) {
                Node current = s.top();
                s.pop();
                states_visited++;

                if (current.state == GOAL) {
                    total_states += states_visited;
                    cout << "IDA* total visited states: " << total_states << endl;
                    //cout << "Solution found with threshold: " << threshold << endl;
                    return current.path;
                }

                if (current.f() > threshold) {
                    next_threshold = min(next_threshold, current.f());
                    continue;
                }

                vector<Node> neighbors = getNeighbors(Node(current.state, current.path, current.empty_pos));
                for (const Node& neighbor : neighbors) {
                    int new_g = current.g + 1;

                    auto it = visited.find(neighbor.state);
                    if (it == visited.end() || new_g < it->second) {
                        int new_h = combinedHeuristic(neighbor.state);
                        int new_f = new_g + new_h;

                        if (new_f <= threshold) {
                            visited[neighbor.state] = new_g;
                            s.push(Node(neighbor.state, neighbor.path, neighbor.empty_pos, new_g, new_h));
                        }
                        else {
                            next_threshold = min(next_threshold, new_f);
                        }
                    }
                }
            }

            total_states += states_visited;

            if (next_threshold == INT_MAX) {
                cout << "IDA*: No solution exists" << endl;
                break;
            }

            threshold = next_threshold;

            if (total_states > stateLim) {
                cout << "IDA*: Total state limit reached" << endl;
                break;
            }

        }

        return "";
    }

    // Воспроизведение решения в файл
    void replaySolution(const string& initial, const string& path, const string& filename) {
        ofstream file(filename);
        if (!file.is_open()) {
            cout << "Cannot open file " << filename << endl;
            return;
        }

        string current_state = initial;
        int empty_pos = initial.find('0');

        file << "Initial state:" << endl;
        printBoardToFile(current_state, file);
        file << endl;

        for (char move : path) {
            int empty_row = empty_pos / SIZE;
            int empty_col = empty_pos % SIZE;
            int new_row = empty_row, new_col = empty_col;

            switch (move) {
            case 'U': new_row--; break;
            case 'D': new_row++; break;
            case 'L': new_col--; break;
            case 'R': new_col++; break;
            }

            int new_pos = new_row * SIZE + new_col;
            swap(current_state[empty_pos], current_state[new_pos]);
            empty_pos = new_pos;

            file << "Move " << move << ":" << endl;
            printBoardToFile(current_state, file);
            file << endl;
        }

        file.close();
    }

    void printBoard(const string& state) {
        cout << "Current set:" << endl;
        for (int i = 0; i < SIZE; i++) {
            for (int j = 0; j < SIZE; j++) {
                char c = state[i * SIZE + j];
                cout << c << " ";
            }
            cout << endl;
        }
    }

    void printBoardToFile(const string& state, ofstream& file) {
        for (int i = 0; i < SIZE; i++) {
            for (int j = 0; j < SIZE; j++) {
                char c = state[i * SIZE + j];
                file << c << " ";
            }
            file << endl;
        }
    }

    bool processInput(string& input) {
        for (char& c : input) {
            if (c >= 'a' && c <= 'f') {
                c = c - 'a' + 'A';
            }
        }
        if (!isValidInput(input)) {
            return false;
        }
        if (!isSolvable(input)) {
            cout << "ERROR Unsolvable position!" << endl;
            return false;
        }
        return true;
    }

    void printSolution(string& input, int typeSol) {// 0-BFS 1-DFS 2-IDS
        if (!processInput(input)) {
            return;
        }

        string solution;
        auto start = high_resolution_clock::now();

        switch (typeSol) {
        case 0:
            solution = solveBFS(input);
            break;
        case 1:
            int states;
            solution = solveDFS(input, 30, states);
            break;
        case 2:
            solution = solveIDS(input);
            break;
        case 3: // A*
            solution = solveAStar(input);
            break;
        case 4: // IDA*
            solution = solveIDAStar(input);
            break;
        }

        auto stop = high_resolution_clock::now();
        auto duration = duration_cast<milliseconds>(stop - start);

        if (solution.empty()) {
            cout << "No solution found" << endl;
        }
        else {
            cout << "Length : " << solution.length() << "; Time : " << duration.count() << " ms;" << endl;
            cout << "Solution: " << solution << endl;

            replaySolution(input, solution, "solution.txt");
        }

    }

    void printAllSolutions(string& input) {
        printBoard(input);
        cout << "=== BFS ===" << endl;
        printSolution(input, 0);
        cout << "=== DFS ===" << endl;
        printSolution(input, 1);
        cout << "=== IDS ===" << endl;
        printSolution(input, 2);
        cout << "=== A* ===" << endl;
        printSolution(input, 3);
        cout << "=== IDA* ===" << endl;
        printSolution(input, 4);
        cout << endl;
    }

    void printNoDFSSolutions(string& input) {
        printBoard(input);
        cout << "=== BFS ===" << endl;
        printSolution(input, 0);
        cout << "=== IDS ===" << endl;
        printSolution(input, 2);
        cout << "=== A* ===" << endl;
        printSolution(input, 3);
        cout << "=== IDA* ===" << endl;
        printSolution(input, 4);
        cout << endl;
    }

    void printASolutions(string& input) {
        printBoard(input);
        cout << "=== A* ===" << endl;
        printSolution(input, 3);
        cout << "=== IDA* ===" << endl;
        printSolution(input, 4);
        cout << endl;
    }
};

int main() {
    Puzzle15Solver solver;
    string input;

    cout << "===ALL SOL===\n" << endl;
    input = "1234067859ACDEBF";//5
    solver.printAllSolutions(input);
    
    cout << "\n===WITHOUT DFS===\n" << endl;
    input = "1723068459ACDEBF"; //13
    solver.printNoDFSSolutions(input);
    input = "12345678A0BE9FCD";//19
    solver.printNoDFSSolutions(input);

    cout << "\n===A SOLS===\n" << endl;
    input = "75123804A6BE9FCD";//35
    solver.printASolutions(input);
    input = "FE169B4C0A73D852";//52
    solver.printASolutions(input);

    return 0;
}