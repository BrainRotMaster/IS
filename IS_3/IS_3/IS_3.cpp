#include <iostream>
#include <vector>
#include <queue>
#include <stack>
#include <unordered_map>
#include <unordered_set>
#include <chrono>
#include <bitset>
#include <array>
#include <functional>
#include <algorithm>
#include <limits>

using namespace std;
using namespace std::chrono;

const int BOARD_SIZE = 4;
const int NUM_PIECES = 4;

// ========== Структура состояния доски ==========
struct BoardState {
    uint64_t white; // позиции белых шашек
    uint64_t black; // позиции черных шашек

    bool operator==(const BoardState& other) const {
        return white == other.white && black == other.black;
    }

    bool isOccupied(int pos) const {
        return (white & (1ULL << pos)) || (black & (1ULL << pos));
    }

    void movePiece(int from, int to, bool isWhite) {
        uint64_t& pieces = isWhite ? white : black;
        pieces &= ~(1ULL << from);
        pieces |= (1ULL << to);
    }

    static int pos(int x, int y) { return y * BOARD_SIZE + x; }
};

struct BoardHash {
    size_t operator()(const BoardState& s) const noexcept {
        return std::hash<uint64_t>()(s.white ^ (s.black << 1));
    }
};

// ========== Узел A* ==========
struct Node {
    BoardState state;
    int g, h, f;
    shared_ptr<Node> parent;
    int moveFrom = -1, moveTo = -1;

    Node(const BoardState& s, int g_, int h_,
        shared_ptr<Node> p = nullptr, int f_ = -1, int t_ = -1)
        : state(s), g(g_), h(h_), parent(p), moveFrom(f_), moveTo(t_) {
        f = (f_ == -1 ? g + h : f_);
    }
};

// ========== Класс решателя ==========
class CornersSolver {
public:
    BoardState initial, goal;
    vector<int> whiteGoalPositions, blackGoalPositions;
    long long nodesExplored = 0;

    CornersSolver() { initGoals(); }

    void initGoals() {
        // Нижний левый угол – белые, верхний правый – чёрные
        for (int y = 0; y < 2; y++)
            for (int x = 0; x < 2; x++)
                whiteGoalPositions.push_back(BoardState::pos(x, y));

        for (int y = 2; y < 4; y++)
            for (int x = 2; x < 4; x++)
                blackGoalPositions.push_back(BoardState::pos(x, y));

        // начальное состояние
        initial.white = 0;
        initial.black = 0;

        for (int y = 2; y < 4; y++)
            for (int x = 2; x < 4; x++)
                initial.white |= 1ULL << BoardState::pos(x, y);

        for (int y = 0; y < 2; y++)
            for (int x = 0; x < 2; x++)
                initial.black |= 1ULL << BoardState::pos(x, y);

        // целевое состояние
        goal.white = initial.black;
        goal.black = initial.white;
    }

    // Манхэттен
    int manhattan(int a, int b) {
        int x1 = a % BOARD_SIZE, y1 = a / BOARD_SIZE;
        int x2 = b % BOARD_SIZE, y2 = b / BOARD_SIZE;
        return abs(x1 - x2) + abs(y1 - y2);
    }

    int hungarian(const vector<vector<int>>& cost) {
        int n = cost.size();
        int m = cost[0].size();
        int dim = max(n, m);
        vector<vector<int>> a(dim, vector<int>(dim, 0));

        for (int i = 0; i < n; i++)
            for (int j = 0; j < m; j++)
                a[i][j] = cost[i][j];

        vector<int> u(dim + 1), v(dim + 1), p(dim + 1), way(dim + 1);

        for (int i = 1; i <= dim; i++) {
            p[0] = i;
            int j0 = 0;
            vector<int> minv(dim + 1, INT_MAX);
            vector<char> used(dim + 1, false);
            do {
                used[j0] = true;
                int i0 = p[j0], delta = INT_MAX, j1 = 0;
                for (int j = 1; j <= dim; j++) {
                    if (used[j]) continue;
                    int cur = a[i0 - 1][j - 1] - u[i0] - v[j];
                    if (cur < minv[j]) minv[j] = cur, way[j] = j0;
                    if (minv[j] < delta) delta = minv[j], j1 = j;
                }
                for (int j = 0; j <= dim; j++) {
                    if (used[j]) { u[p[j]] += delta; v[j] -= delta; }
                    else minv[j] -= delta;
                }
                j0 = j1;
            } while (p[j0] != 0);
            do {
                int j1 = way[j0];
                p[j0] = p[j1];
                j0 = j1;
            } while (j0);
        }

        return -v[0]; // минимальная стоимость
    }


    // ========== Эвристика ==========
    int advancedHeuristic(const BoardState& state) {
        if (state == goal) return 0;

        vector<int> whitePositions, blackPositions;
        for (int pos = 0; pos < 16; pos++) {
            if (state.white & (1ULL << pos)) whitePositions.push_back(pos);
            if (state.black & (1ULL << pos)) blackPositions.push_back(pos);
        }

        auto buildCost = [&](const vector<int>& from, const vector<int>& to) {
            vector<vector<int>> cost(from.size(), vector<int>(to.size()));
            for (int i = 0; i < (int)from.size(); i++)
                for (int j = 0; j < (int)to.size(); j++)
                    cost[i][j] = manhattan(from[i], to[j]);
            return cost;
            };

        int distW = hungarian(buildCost(whitePositions, whiteGoalPositions));
        int distB = hungarian(buildCost(blackPositions, blackGoalPositions));

        return (distW + distB);
    }


    // ========== Мультипрыжки ==========
    void addJumpChains(const BoardState& state, int pos, bool isWhite,
        vector<pair<BoardState, pair<int, int>>>& moves,
        unordered_set<int> visited) {
        int x = pos % BOARD_SIZE;
        int y = pos / BOARD_SIZE;
        int dx[] = { 1, -1, 0, 0 };
        int dy[] = { 0, 0, 1, -1 };

        for (int i = 0; i < 4; i++) {
            int mx = x + dx[i];
            int my = y + dy[i];
            int jx = x + 2 * dx[i];
            int jy = y + 2 * dy[i];
            if (jx < 0 || jy < 0 || jx >= BOARD_SIZE || jy >= BOARD_SIZE)
                continue;

            int mid = BoardState::pos(mx, my);
            int jump = BoardState::pos(jx, jy);

            if (state.isOccupied(mid) && !state.isOccupied(jump) && !visited.count(jump)) {
                BoardState newState = state;
                newState.movePiece(pos, jump, isWhite);
                moves.emplace_back(newState, make_pair(pos, jump));

                auto newVisited = visited;
                newVisited.insert(pos);
                addJumpChains(newState, jump, isWhite, moves, newVisited);
            }
        }
    }

    void addMovesForPiece(const BoardState& state, int pos, bool isWhite,
        vector<pair<BoardState, pair<int, int>>>& moves) {
        int x = pos % BOARD_SIZE;
        int y = pos / BOARD_SIZE;
        int dx[] = { 1, -1, 0, 0 };
        int dy[] = { 0, 0, 1, -1 };

        // простые ходы
        for (int i = 0; i < 4; i++) {
            int nx = x + dx[i];
            int ny = y + dy[i];
            if (nx >= 0 && nx < BOARD_SIZE && ny >= 0 && ny < BOARD_SIZE) {
                int np = BoardState::pos(nx, ny);
                if (!state.isOccupied(np)) {
                    BoardState newState = state;
                    newState.movePiece(pos, np, isWhite);
                    moves.emplace_back(newState, make_pair(pos, np));
                }
            }
        }

        // цепочки прыжков
        unordered_set<int> visited;
        addJumpChains(state, pos, isWhite, moves, visited);
    }

    vector<pair<BoardState, pair<int, int>>> getMoves(const BoardState& state) {
        vector<pair<BoardState, pair<int, int>>> moves;
        for (int pos = 0; pos < 16; pos++) {
            if (state.white & (1ULL << pos))
                addMovesForPiece(state, pos, true, moves);
            else if (state.black & (1ULL << pos))
                addMovesForPiece(state, pos, false, moves);
        }

        // фильтр дубликатов
        unordered_set<uint64_t> seen;
        vector<pair<BoardState, pair<int, int>>> unique;
        for (auto& m : moves) {
            uint64_t h = m.first.white ^ (m.first.black << 1);
            if (!seen.count(h)) {
                seen.insert(h);
                unique.push_back(m);
            }
        }
        return unique;
    }

    // ========== Восстановление пути ==========
    vector<pair<int, int>> reconstructPath(shared_ptr<Node> node) {
        vector<pair<int, int>> path;
        while (node && node->parent) {
            path.emplace_back(node->moveFrom, node->moveTo);
            node = node->parent;
        }
        reverse(path.begin(), path.end());
        return path;
    }

    // ========== Решатель A* ==========
    vector<pair<int, int>> solveAStar() {
        auto startTime = high_resolution_clock::now();
        nodesExplored = 0;

        struct Cmp {
            bool operator()(const shared_ptr<Node>& a, const shared_ptr<Node>& b) const {
                return a->f > b->f;
            }
        };

        priority_queue<shared_ptr<Node>, vector<shared_ptr<Node>>, Cmp> openSet;
        unordered_map<BoardState, int, BoardHash> gValues;
        unordered_set<BoardState, BoardHash> closedSet;

        int h0 = advancedHeuristic(initial);
        auto start = make_shared<Node>(initial, 0, h0);
        openSet.push(start);
        gValues[initial] = 0;

        int bestF = INT_MAX;

        cout << "A* started (h=" << h0 << ")\n";

        while (!openSet.empty()) {
            auto current = openSet.top();
            openSet.pop();

            if (closedSet.count(current->state)) continue;
            closedSet.insert(current->state);
            nodesExplored++;

            if (current->state == goal) {
                auto endTime = high_resolution_clock::now();
                auto dur = duration_cast<milliseconds>(endTime - startTime);
                cout << "\n✅ A* completed in " << dur.count() << " ms, "
                    << nodesExplored << " nodes.\n";
                return reconstructPath(current);
            }

            if (nodesExplored > 5000000) {
                cout << "⚠️  Search stopped (too many nodes)\n";
                return reconstructPath(current);
            }

            auto nextMoves = getMoves(current->state);
            for (auto& mv : nextMoves) {
                const BoardState& ns = mv.first;
                int newG = current->g + 1;
                if (closedSet.count(ns)) continue;

                int newH = advancedHeuristic(ns);
                int newF = newG + int(newH * 1.2); // Weighted A*
                if (newF >= bestF) continue;

                if (!gValues.count(ns) || newG < gValues[ns]) {
                    gValues[ns] = newG;
                    auto newNode = make_shared<Node>(ns, newG, newH, current,
                        mv.second.first, mv.second.second);
                    openSet.push(newNode);
                    if (newH == 0) bestF = min(bestF, newF);
                }
            }

            if (nodesExplored % 10000 == 0) {
                auto t = duration_cast<milliseconds>(
                    high_resolution_clock::now() - startTime);
                cout << "A* explored " << nodesExplored
                    << " nodes, f=" << current->f
                    << " (g=" << current->g << ", h=" << current->h << ")"
                    << ", time=" << t.count() << " ms\n";
            }
        }

        cout << "❌ No solution found.\n";
        return {};
    }

private:
    // Преобразовать позицию в шахматную нотацию
    string positionToNotation(int pos) {
        int x = pos % BOARD_SIZE;
        int y = pos / BOARD_SIZE;
        string result = "";
        result += char('A' + x);
        result += char('1' + y);
        return result;
    }

public:
    void printBoard(const BoardState& state) {
        cout << "  A B C D E F G H" << endl;
        for (int y = 0; y < BOARD_SIZE; y++) {
            cout << (y + 1) << " ";
            for (int x = 0; x < BOARD_SIZE; x++) {
                int pos = BoardState::pos(x, y);
                if (state.white & (1ULL << pos)) {
                    cout << "W ";
                }
                else if (state.black & (1ULL << pos)) {
                    cout << "B ";
                }
                else {
                    cout << ". ";
                }
            }
            cout << endl;
        }
        cout << endl;
    }

    void printSolution(const vector<pair<int, int>>& path) {
        if (path.empty()) {
            cout << "No solution to display." << endl;
            return;
        }

        BoardState currentState = initial;
        cout << "Initial state:" << endl;
        printBoard(currentState);

        for (size_t i = 0; i < path.size(); i++) {
            int from = path[i].first;
            int to = path[i].second;

            cout << "Move " << (i + 1) << ": " << positionToNotation(from)
                << " -> " << positionToNotation(to) << endl;

            // Обновить состояние
            bool isWhite = currentState.white & (1ULL << from);
            currentState.movePiece(from, to, isWhite);

            if (i < 5 || i >= path.size() - 5) {  // Показать первые и последние 5 ходов
                printBoard(currentState);
            }
        }

        cout << "Final state:" << endl;
        printBoard(currentState);
    }

    BoardState getInitialState() const { return initial; }
    BoardState getGoalState() const { return goal; }
};

int main() {
    CornersSolver solver;
    auto path = solver.solveAStar();

    cout << "\nMoves: " << path.size() << "\n";
    for (auto& move : path)  // используем ссылку для избежания копирования
        cout << move.first << " -> " << move.second << "\n";

    return 0;  // хорошая практика - добавлять return
}
