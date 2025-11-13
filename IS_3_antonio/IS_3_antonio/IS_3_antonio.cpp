#include <iostream>
#include <queue>
#include <unordered_map>
#include <stack>
#include <vector>
#include <string>
#include <algorithm>
#include <cmath>
#include <functional>
#include <unordered_set>

using namespace std;

//A*

struct Position { int row, col; };

// '0' - пусто, '1' - белая, '2' - черная
struct BoardState {
    int rows = 8, cols = 8;
    string board;

    bool operator==(const BoardState& other) const { return board == other.board; }
};

static inline int index(int row, int col, int cols) { return row * cols + col; }

struct BoardHasher {
    size_t operator()(const BoardState& state) const noexcept { return hash<string>{}(state.board); }
};

struct CornersTask {
    int rows, cols, rectRows, rectCols;
    BoardState start, goal;

    CornersTask(int rows_, int cols_, int rectRows_, int rectCols_) : rows(rows_), cols(cols_), rectRows(rectRows_), rectCols(rectCols_) {
        start.rows = rows;
        start.cols = cols;
        goal.rows = rows;
        goal.cols = cols;
        start.board.assign(rows * cols, '0');
        goal.board.assign(rows * cols, '0');

        for (int r = 0; r < rectRows; r++)
            for (int c = 0; c < rectCols; c++) {
                start.board[index(r, c, cols)] = '1';
                goal.board[index(r, c, cols)] = '2';
            }

        for (int r = rows - rectRows; r < rows; r++)
            for (int c = cols - rectCols; c < cols; c++) {
                start.board[index(r, c, cols)] = '2';
                goal.board[index(r, c, cols)] = '1';
            }
    }

    vector<pair<BoardState, string>> getNeighbors(const BoardState& state) const {
        static const int dRow[4] = { -1, 1, 0, 0 };
        static const int dCol[4] = { 0, 0, -1, 1 };
        vector<pair<BoardState, string>> neighbors;

        for (int row = 0; row < rows; row++) {
            for (int col = 0; col < cols; col++) {
                char piece = state.board[index(row, col, cols)];
                if (piece == '0') continue;

                for (int direction = 0; direction < 4; direction++) {
                    int newRow = row + dRow[direction], newCol = col + dCol[direction];
                    if (newRow < 0 || newRow >= rows || newCol < 0 || newCol >= cols) continue;

                    int newIndex = index(newRow, newCol, cols);
                    if (state.board[newIndex] == '0') {
                        //шаг
                        BoardState nextState = state;
                        swap(nextState.board[index(row, col, cols)], nextState.board[newIndex]);
                        string action = string(1, piece) == "1" ?
                            "white (" + to_string(row) + ", " + to_string(col) + ") -> (" + to_string(newRow) + ", " + to_string(newCol) + ")" :
                            "black (" + to_string(row) + ", " + to_string(col) + ") -> (" + to_string(newRow) + ", " + to_string(newCol) + ")";
                        neighbors.emplace_back(move(nextState), move(action));
                    }
                    else {
                        //Прыжок
                        int nextRow = newRow + dRow[direction], nextCol = newCol + dCol[direction];
                        if (nextRow < 0 || nextRow >= rows || nextCol < 0 || nextCol >= cols) continue;

                        int nextIndex = index(nextRow, nextCol, cols);
                        if (state.board[nextIndex] == '0') {
                            BoardState nextState = state;
                            nextState.board[nextIndex] = piece;
                            nextState.board[index(row, col, cols)] = '0';
                            string action = string(1, piece) == "1" ?
                                "white (" + to_string(row) + ", " + to_string(col) + ") -> (" + to_string(nextRow) + ", " + to_string(nextCol) + ")" :
                                "black (" + to_string(row) + ", " + to_string(col) + ") -> (" + to_string(nextRow) + ", " + to_string(nextCol) + ")";
                            neighbors.emplace_back(move(nextState), move(action));
                        }
                    }
                }
            }
        }
        return neighbors;
    }

    bool isGoal(const BoardState& state) const {
        return state.board == goal.board;
    }
};

static vector<Position> getAllPosByColor(const string& board, int rows, int cols, char piece) {
    vector<Position> positions;
    for (int row = 0; row < rows; row++) {
        for (int col = 0; col < cols; col++) {
            if (board[index(row, col, cols)] == piece)
                positions.push_back({ row, col });
        }
    }
    return positions;
}

static int manhattanDistance(Position a, Position b) {
    return abs(a.row - b.row) + abs(a.col - b.col);
}

static int hungarianMinCost(const vector<vector<int>>& a) {
    int n = a.size();
    const int INF = 1e9;
    vector<int> u(n + 1), v(n + 1), p(n + 1), way(n + 1);
    for (int i = 1; i <= n; i++) {
        p[0] = i;
        int j0 = 0;
        vector<int> minv(n + 1, INF);
        vector<char> used(n + 1, false);
        do {
            used[j0] = true;
            int i0 = p[j0], delta = INF, j1 = 0;
            for (int j = 1; j <= n; j++)
                if (!used[j]) {
                    // редуцированная стоимость cur = a[i0-1][j-1] - u[i0] - v[j]
                    int cur = a[i0 - 1][j - 1] - u[i0] - v[j];
                    if (cur < minv[j]) minv[j] = cur, way[j] = j0;
                    if (minv[j] < delta) delta = minv[j], j1 = j;
                }
            // сдвиг потенциалов: у посещённых уменьшаем v, у соответствующих строк увеличиваем u;
            // у непосещённых уменьшаем запас minv (slack)
            for (int j = 0; j <= n; j++) {
                if (used[j])
                    u[p[j]] += delta, v[j] -= delta;
                else minv[j] -= delta;
            }
            j0 = j1; // расширяем дерево по новому нулевому ребру
        } while (p[j0] != 0);
        // восстановление увеличивающего пути и переворот паросочетания
        do { int j1 = way[j0]; p[j0] = p[j1]; j0 = j1; } while (j0);
    }
    return -v[0]; // минимальная стоимость
}

static int advancedHeuristic(const CornersTask& task, const BoardState& state) {
    auto currentWhite = getAllPosByColor(state.board, task.rows, task.cols, '1');
    auto currentBlack = getAllPosByColor(state.board, task.rows, task.cols, '2');
    auto goalWhite = getAllPosByColor(task.goal.board, task.rows, task.cols, '1');
    auto goalBlack = getAllPosByColor(task.goal.board, task.rows, task.cols, '2');

    int cost = 0;
    if (!currentWhite.empty()) {
        vector<vector<int>> costMatrix(currentWhite.size(), vector<int>(goalWhite.size()));
        for (size_t i = 0; i < currentWhite.size(); i++) {
            for (size_t j = 0; j < goalWhite.size(); j++) {
                costMatrix[i][j] = (manhattanDistance(currentWhite[i], goalWhite[j]) + 1) / 2;
            }
        }
        cost += hungarianMinCost(costMatrix);
    }

    if (!currentBlack.empty()) {
        vector<vector<int>> costMatrix(currentBlack.size(), vector<int>(goalBlack.size()));
        for (size_t i = 0; i < currentBlack.size(); i++) {
            for (size_t j = 0; j < goalBlack.size(); j++) {
                costMatrix[i][j] = (manhattanDistance(currentBlack[i], goalBlack[j]) + 1) / 2;
            }
        }
        cost += hungarianMinCost(costMatrix);
    }

    return cost;
}


static vector<string> AStarSolver(const CornersTask& task, int maxExpansions = 1000000) {
    struct Node {
        BoardState state;
        int gCost, hCost;
        string boardKey;
        Node(const BoardState& state_, int gCost_, int hCost_, const string& key_)
            : state(state_), gCost(gCost_), hCost(hCost_), boardKey(key_) {
        }
    };

    struct CompareNodes {
        bool operator()(const Node& a, const Node& b) const { return a.gCost + a.hCost > b.gCost + b.hCost; }
    };

    priority_queue<Node, vector<Node>, CompareNodes> openSet;
    unordered_map<string, int> bestG;
    unordered_map<string, pair<string, string>> parent;

    BoardState startState = task.start;
    openSet.push({ startState, 0, advancedHeuristic(task, startState), startState.board });
    bestG[startState.board] = 0;
    parent[startState.board] = { "", "START" };

    int expansions = 0;
    while (!openSet.empty()) {
        Node currentNode = openSet.top();
        openSet.pop();
        if (expansions++ > maxExpansions) break;

        if (task.isGoal(currentNode.state)) {
            vector<string> path;
            string key = currentNode.boardKey;
            while (true) {
                auto parentData = parent[key];
                string action = parentData.second;
                if (action != "START") path.push_back(action);
                if (parentData.first.empty()) break;
                key = parentData.first;
            }
            reverse(path.begin(), path.end());
            return path;
        }

        auto neighbors = task.getNeighbors(currentNode.state);
        for (auto& neighbor : neighbors) {
            BoardState nextState = neighbor.first;
            string action = neighbor.second;
            int newGCost = currentNode.gCost + 1;
            string nextKey = nextState.board;

            if (bestG.find(nextKey) == bestG.end() || newGCost < bestG[nextKey]) {
                bestG[nextKey] = newGCost;
                parent[nextKey] = { currentNode.boardKey, action };
                openSet.push(Node(nextState, newGCost, advancedHeuristic(task, nextState), nextKey));
            }
        }
    }

    return {};
}

//DFS/IDS

static vector<string> DFSSolver(const CornersTask& task) {
    stack<pair<BoardState, vector<string>>> stack;
    unordered_set<string> visited;

    stack.push({ task.start, {} });
    visited.insert(task.start.board);

    while (!stack.empty()) {
        auto top = stack.top();
        BoardState currentState = top.first;
        vector<string> path = top.second;
        stack.pop();

        if (task.isGoal(currentState)) {
            return path;
        }

        auto neighbors = task.getNeighbors(currentState);
        for (auto& neighbor : neighbors) {
            const BoardState& nextState = neighbor.first;
            const string& action = neighbor.second;

            if (visited.find(nextState.board) == visited.end()) {
                visited.insert(nextState.board);
                vector<string> newPath = path;
                newPath.push_back(action);
                stack.push({ nextState, newPath });
            }
        }
    }

    return {};
}

static vector<string> IDSSolver(const CornersTask& task, int maxDepth = 20) {
    for (int depth = 0; depth <= maxDepth; depth++) {
        vector<string> solution;
        /*if (DFSWithLimit(task, task.start, solution, depth)) {
            return solution;
        }*/
    }
    return {};
}

static bool DFSWithLimit(const CornersTask& task, const BoardState& state, vector<string>& path, int limit) {
    if (limit == 0) {
        if (task.isGoal(state)) {
            return true;
        }
        return false;
    }

    auto neighbors = task.getNeighbors(state);
    for (auto& neighbor : neighbors) {
        const BoardState& nextState = neighbor.first;
        const string& action = neighbor.second;

        path.push_back(action);
        if (DFSWithLimit(task, nextState, path, limit - 1)) {
            return true;
        }
        path.pop_back();
    }

    return false;
}

int main() {
    int rows = 8, cols = 8, rectRows = 2, rectCols = 2;

    CornersTask task(rows, cols, rectRows, rectCols);

    auto solution = AStarSolver(task);
    if (!solution.empty()) {
        cout << "A* found a solution" << endl;
        cout << "Total moves: " << solution.size() << endl;
        for (size_t i = 0; i < solution.size(); ++i) {
            cout << (i + 1) << ". " << solution[i] << endl;
        }
    }
    else {
        cout << "A* did not find a solution" << endl;
    }


    return 0;
}