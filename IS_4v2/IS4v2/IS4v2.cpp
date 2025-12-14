#include <iostream>
#include <vector>
#include <string>
#include <algorithm>
#include <map>
#include <set>
#include <chrono>
#include <sstream>
#include <memory>
#include <climits>
#include <random>

using namespace std;

// Константы времени
const int TIME_LIMIT_MS = 5000;

// Структура для хранения позиции
struct Position {
    int x, y;
    Position() : x(-1), y(-1) {}
    Position(int x, int y) : x(x), y(y) {}

    bool operator==(const Position& other) const {
        return x == other.x && y == other.y;
    }

    bool operator<(const Position& other) const {
        if (x != other.x) return x < other.x;
        return y < other.y;
    }
};

// Класс для игры в Мельницу
class MillGame {
private:
    vector<vector<char>> board;
    int playerPieces[2]; // Фишки на поле установленные [0] - X, [1] - O
    int playerHand[2];   // Фишки на руках
    bool phaseOfSet;     // true = фаза расстановки, false = фаза движения
    vector<vector<Position>> moveHistory;

    // Все возможные мельницы
    const vector<vector<Position>> mills = {
        {Position(0,0), Position(0,3), Position(0,6)},
        {Position(1,1), Position(1,3), Position(1,5)},
        {Position(2,2), Position(2,3), Position(2,4)},
        {Position(4,2), Position(4,3), Position(4,4)},
        {Position(5,1), Position(5,3), Position(5,5)},
        {Position(6,0), Position(6,3), Position(6,6)},

        {Position(3,0), Position(3,1), Position(3,2)},
        {Position(3,4), Position(3,5), Position(3,6)},

        {Position(0,0), Position(3,0), Position(6,0)},
        {Position(1,1), Position(3,1), Position(5,1)},
        {Position(2,2), Position(3,2), Position(4,2)},
        {Position(2,4), Position(3,4), Position(4,4)},
        {Position(1,5), Position(3,5), Position(5,5)},
        {Position(0,6), Position(3,6), Position(6,6)},

        {Position(0,3), Position(1,3), Position(2,3)},
        {Position(4,3), Position(5,3), Position(6,3)}
    };

    // Соседние позиции для движения
    map<Position, vector<Position>> neighbors;

public:
    MillGame() {
        board = vector<vector<char>>(7, vector<char>(7, ' '));

        vector<Position> validPositions = {
            {0,0}, {0,3}, {0,6},
            {1,1}, {1,3}, {1,5},
            {2,2}, {2,3}, {2,4},
            {3,0}, {3,1}, {3,2}, {3,4}, {3,5}, {3,6},
            {4,2}, {4,3}, {4,4},
            {5,1}, {5,3}, {5,5},
            {6,0}, {6,3}, {6,6}
        };

        for (const auto& pos : validPositions) {
            board[pos.x][pos.y] = '.';
        }

        neighbors = {
            {Position(0,0), {Position(0,3), Position(3,0)}},
            {Position(0,3), {Position(0,0), Position(0,6), Position(1,3)}},
            {Position(0,6), {Position(0,3), Position(3,6)}},

            {Position(1,1), {Position(1,3), Position(3,1)}},
            {Position(1,3), {Position(0,3), Position(1,1), Position(1,5), Position(2,3)}},
            {Position(1,5), {Position(1,3), Position(3,5)}},

            {Position(2,2), {Position(2,3), Position(3,2)}},
            {Position(2,3), {Position(1,3), Position(2,2), Position(2,4)}},
            {Position(2,4), {Position(2,3), Position(3,4)}},

            {Position(3,0), {Position(0,0), Position(3,1), Position(6,0)}},
            {Position(3,1), {Position(1,1), Position(3,0), Position(3,2), Position(5,1)}},
            {Position(3,2), {Position(2,2), Position(3,1), Position(4,2)}},
            {Position(3,4), {Position(2,4), Position(3,5), Position(4,4)}},
            {Position(3,5), {Position(1,5), Position(3,4), Position(3,6), Position(5,5)}},
            {Position(3,6), {Position(0,6), Position(3,5), Position(6,6)}},

            {Position(4,2), {Position(3,2), Position(4,3)}},
            {Position(4,3), {Position(4,2), Position(4,4), Position(5,3)}},
            {Position(4,4), {Position(3,4), Position(4,3)}},

            {Position(5,1), {Position(3,1), Position(5,3)}},
            {Position(5,3), {Position(4,3), Position(5,1), Position(5,5), Position(6,3)}},
            {Position(5,5), {Position(3,5), Position(5,3)}},

            {Position(6,0), {Position(3,0), Position(6,3)}},
            {Position(6,3), {Position(5,3), Position(6,0), Position(6,6)}},
            {Position(6,6), {Position(3,6), Position(6,3)}}
        };

        playerPieces[0] = playerPieces[1] = 0;
        playerHand[0] = playerHand[1] = 9;
        phaseOfSet = true;
    }

    // Конвертация строки в позицию
    Position stringToPos(const string& coord) const {
        if (coord.length() != 2) return Position(-1, -1);
        char col = coord[0];
        char row = coord[1];

        int x = row - '1';
        int y = col - 'a';

        if (x < 0 || x >= 7 || y < 0 || y >= 7) return Position(-1, -1);
        return Position(x, y);
    }

    // Конвертация позиции в строку
    string posToString(const Position& pos) const {
        if (pos.x < 0 || pos.x >= 7 || pos.y < 0 || pos.y >= 7) return "";
        string result = "";
        result += char('a' + pos.y);
        result += char('1' + pos.x);
        return result;
    }

    // Проверка валидности позиции
    bool isValidPosition(const Position& pos) const {
        if (pos.x < 0 || pos.x >= 7 || pos.y < 0 || pos.y >= 7) return false;
        return board[pos.x][pos.y] != ' ';
    }

    // Получить символ игрока X/O
    char getPlayerSymbol(int player) const {
        return (player == 0) ? 'X' : 'O';
    }

    // Получить индекс игрока 0/1
    int getCurrentPlayer() const {
        return moveHistory.size() % 2;
    }

    // Проверка образования мельницы для позиции
    vector<vector<Position>> checkMill(const Position& pos, int player) const {
        vector<vector<Position>> completedMills;
        char symbol = getPlayerSymbol(player);

        for (const auto& mill : mills) {
            if (find(mill.begin(), mill.end(), pos) != mill.end()) {
                bool isMill = true;
                for (const auto& p : mill) {
                    if (board[p.x][p.y] != symbol) {
                        isMill = false;
                        break;
                    }
                }
                if (isMill) {
                    completedMills.push_back(mill);
                }
            }
        }

        return completedMills;
    }

    // Получить все фишки противника, которые можно забрать
    vector<Position> getRemovablePieces(int player) const {
        vector<Position> removable;
        char opponentSymbol = getPlayerSymbol(1 - player);

        // Сначала фишки не входящие в мельницы
        vector<Position> inMills;
        vector<Position> notInMills;

        for (int i = 0; i < 7; i++) {
            for (int j = 0; j < 7; j++) {
                if (board[i][j] == opponentSymbol) {
                    Position pos(i, j);
                    bool inMill = false;
                    for (const auto& mill : mills) {
                        if (find(mill.begin(), mill.end(), pos) != mill.end()) {
                            bool completeMill = true;
                            for (const auto& p : mill) {
                                if (board[p.x][p.y] != opponentSymbol) {
                                    completeMill = false;
                                    break;
                                }
                            }
                            if (completeMill) {
                                inMill = true;
                                break;
                            }
                        }
                    }
                    if (inMill) {
                        inMills.push_back(pos);
                    }
                    else {
                        notInMills.push_back(pos);
                    }
                }
            }
        }

        if (!notInMills.empty()) {
            return notInMills;
        }

        return inMills;
    }

    bool makeMove(const vector<string>& moveParts, int player) {
        if (moveParts.empty()) return false;

        // Отмена хода (для человека)
        if (moveParts[0] == "u1") {
            return undoMove();
        }

        vector<Position> currentMove;

        if (phaseOfSet) {
            // Фаза расстановки
            Position newPos = stringToPos(moveParts[0]);
            if (!isValidPosition(newPos) || board[newPos.x][newPos.y] != '.') return false;

            // Устанавливаем фишку
            board[newPos.x][newPos.y] = getPlayerSymbol(player);
            playerHand[player]--;
            playerPieces[player]++;
            currentMove.push_back(newPos);

            // Проверяем образование мельницы
            auto millsFormed = checkMill(newPos, player);

            if (!millsFormed.empty()) {
                if ((moveParts.size() - 1) < 1) {
                    board[newPos.x][newPos.y] = '.';
                    playerHand[player]++;
                    playerPieces[player]--;
                    return false;
                }

                // Забираем фишку противника
                for (size_t i = 1; i < moveParts.size(); i++) {
                    Position removePos = stringToPos(moveParts[i]);
                    if (!isValidPosition(removePos)) {
                        board[newPos.x][newPos.y] = '.';
                        playerHand[player]++;
                        playerPieces[player]--;
                        return false;
                    }
                    if (board[removePos.x][removePos.y] == getPlayerSymbol(1 - player)) {
                        board[removePos.x][removePos.y] = '.';
                        playerPieces[1 - player]--;
                        currentMove.push_back(removePos);
                    }
                    else {
                        board[newPos.x][newPos.y] = '.';
                        playerHand[player]++;
                        playerPieces[player]--;
                        return false;
                    }
                }
            }
            moveHistory.push_back(currentMove);

        }
        else {
            if (moveParts.size() < 2) return false;

            Position fromPos = stringToPos(moveParts[0]);
            Position toPos = stringToPos(moveParts[1]);

            if (!isValidPosition(fromPos) || !isValidPosition(toPos)) return false;
            if (board[fromPos.x][fromPos.y] != getPlayerSymbol(player) || board[toPos.x][toPos.y] != '.') {
                return false;
            }

            // Проверка расположения позиций
            bool canFly = (playerPieces[player] <= 3);
            bool isNeighbours = false;
            if (!canFly) {
                auto it = neighbors.find(fromPos);
                if (it != neighbors.end()) {
                    auto& fromNeighbors = it->second;
                    if (find(fromNeighbors.begin(), fromNeighbors.end(), toPos) != fromNeighbors.end()) isNeighbours = true;
                }
                if (!isNeighbours) return false;
            }

            board[fromPos.x][fromPos.y] = '.';
            board[toPos.x][toPos.y] = getPlayerSymbol(player);
            currentMove.push_back(fromPos);
            currentMove.push_back(toPos);

            // Проверяем образование мельницы
            auto millsFormed = checkMill(toPos, player);

            if (!millsFormed.empty()) {
                if (moveParts.size() < 3) {
                    board[toPos.x][toPos.y] = '.';
                    board[fromPos.x][fromPos.y] = getPlayerSymbol(player);
                    return false;
                }

                for (size_t i = 2; i < moveParts.size(); i++) {
                    Position removePos = stringToPos(moveParts[i]);
                    if (!isValidPosition(removePos)) {
                        board[toPos.x][toPos.y] = '.';
                        board[fromPos.x][fromPos.y] = getPlayerSymbol(player);
                        return false;
                    }
                    if (board[removePos.x][removePos.y] == getPlayerSymbol(1 - player)) {
                        board[removePos.x][removePos.y] = '.';
                        playerPieces[1 - player]--;
                        currentMove.push_back(removePos);
                    }
                    else {
                        board[toPos.x][toPos.y] = '.';
                        board[fromPos.x][fromPos.y] = getPlayerSymbol(player);
                        return false;
                    }
                }
            }
            moveHistory.push_back(currentMove);
        }

        // Проверяем переход ко второй фазе
        if (phaseOfSet && playerHand[0] == 0 && playerHand[1] == 0) {
            phaseOfSet = false;
        }

        return true;
    }

    // Отмена хода
    bool undoMove() {
        if (moveHistory.empty()) return false;

        vector<Position> lastMove = moveHistory.back();
        int movePlayer = ((moveHistory.size() - 1) % 2 == 0) ? 0 : 1;
        moveHistory.pop_back();

        if (phaseOfSet) {
            Position placedPos = lastMove[0];
            for (size_t i = 1; i < lastMove.size(); i++) {
                Position removedPos = lastMove[i];
                board[removedPos.x][removedPos.y] = getPlayerSymbol(1 - movePlayer);
                playerPieces[1 - movePlayer]++;
            }
            board[placedPos.x][placedPos.y] = '.';
            playerHand[movePlayer]++;
            playerPieces[movePlayer]--;
        }
        else {
            Position fromPos = lastMove[0];
            Position toPos = lastMove[1];
            for (size_t i = 2; i < lastMove.size(); i++) {
                Position removedPos = lastMove[i];
                board[removedPos.x][removedPos.y] = getPlayerSymbol(1 - movePlayer);
                playerPieces[1 - movePlayer]++;
            }
            board[toPos.x][toPos.y] = '.';
            board[fromPos.x][fromPos.y] = getPlayerSymbol(movePlayer);
        }

        // Если после отката у кого то остались фишки на руках вернуть фазу расстановки
        if (!phaseOfSet && (playerHand[0] > 0 || playerHand[1] > 0)) phaseOfSet = true;

        return true;
    }

    // Проверка окончания игры
    int checkGameOver() const {
        if (!phaseOfSet) {
            if (playerPieces[0] <= 2) return 1;
            if (playerPieces[1] <= 2) return 0;
        }

        if (!phaseOfSet) {
            for (int player = 0; player < 2; player++) {
                bool canMove = false;
                for (int i = 0; i < 7 && !canMove; i++) {
                    for (int j = 0; j < 7 && !canMove; j++) {
                        if (board[i][j] == getPlayerSymbol(player)) {
                            Position pos(i, j);
                            if (playerPieces[player] <= 3) {
                                for (int ii = 0; ii < 7 && !canMove; ii++) for (int jj = 0; jj < 7 && !canMove; jj++) if (board[ii][jj] == '.') canMove = true;
                            }
                            else {
                                auto it = neighbors.find(pos);
                                if (it != neighbors.end()) {
                                    for (const auto& neighbor : it->second) {
                                        if (board[neighbor.x][neighbor.y] == '.') { canMove = true; break; }
                                    }
                                }
                            }
                        }
                    }
                }
                if (!canMove) return 1 - player;
            }
        }

        if (moveHistory.size() > 218) return 3; // ничья
        return -1;
    }

    // Получить все возможные ходы для игрока
    vector<vector<string>> getPossibleMoves(int player) const {
        vector<vector<string>> moves;

        if (phaseOfSet) {
            for (int i = 0; i < 7; i++) {
                for (int j = 0; j < 7; j++) {
                    if (board[i][j] == '.') {
                        Position pos(i, j);
                        vector<string> move = { posToString(pos) };

                        bool formsMill = false;
                        {
                            // подсчитать для мельниц содержащих pos
                            for (const auto& mill : mills) {
                                if (find(mill.begin(), mill.end(), pos) != mill.end()) {
                                    int count = 0; int empt = 0;
                                    for (const auto& p : mill) {
                                        if (board[p.x][p.y] == getPlayerSymbol(player)) count++;
                                        else if (board[p.x][p.y] == '.') empt++;
                                    }
                                    if (count == 2 && empt == 1) { formsMill = true; break; }
                                }
                            }
                        }

                        if (formsMill) {
                            auto removable = getRemovablePieces(player);
                            for (const auto& removePos : removable) {
                                vector<string> moveWithRemove = move;
                                moveWithRemove.push_back(posToString(removePos));
                                moves.push_back(moveWithRemove);
                            }
                        }
                        else {
                            moves.push_back(move);
                        }
                    }
                }
            }
        }
        else {
            for (int i = 0; i < 7; i++) {
                for (int j = 0; j < 7; j++) {
                    if (board[i][j] == getPlayerSymbol(player)) {
                        Position fromPos(i, j);
                        bool canFly = (playerPieces[player] <= 3);

                        if (canFly) {
                            // Может походить на любую пустую позицию
                            for (int ii = 0; ii < 7; ii++) for (int jj = 0; jj < 7; jj++) if (board[ii][jj] == '.') {
                                Position toPos(ii, jj);
                                vector<string> move = { posToString(fromPos), posToString(toPos) };

                                // Проверяем мельницу
                                bool formsMill = false;
                                for (const auto& mill : mills) {
                                    if (find(mill.begin(), mill.end(), toPos) != mill.end()) {
                                        int count = 0; int empt = 0;
                                        for (const auto& p : mill) {
                                            if (p == fromPos) continue;
                                            if (board[p.x][p.y] == getPlayerSymbol(player)) count++;
                                            else if (board[p.x][p.y] == '.') empt++;
                                        }
                                        if (count == 2 || (count == 1 && empt == 1)) { formsMill = true; break; }
                                    }
                                }

                                if (formsMill) {
                                    auto removable = getRemovablePieces(player);
                                    for (const auto& removePos : removable) {
                                        vector<string> moveWithRemove = move;
                                        moveWithRemove.push_back(posToString(removePos));
                                        moves.push_back(moveWithRemove);
                                    }
                                }
                                else moves.push_back(move);
                            }
                        }
                        else {
                            auto it = neighbors.find(fromPos);
                            if (it == neighbors.end()) continue;
                            for (const auto& toPos : it->second) {
                                if (board[toPos.x][toPos.y] == '.') {
                                    vector<string> move = { posToString(fromPos), posToString(toPos) };

                                    // Проверяем мельницу
                                    bool formsMill = false;
                                    for (const auto& mill : mills) {
                                        if (find(mill.begin(), mill.end(), toPos) != mill.end()) {
                                            int count = 0; int empt = 0;
                                            for (const auto& p : mill) {
                                                if (p == fromPos) continue;
                                                if (board[p.x][p.y] == getPlayerSymbol(player)) count++;
                                                else if (board[p.x][p.y] == '.') empt++;
                                            }
                                            if (count == 2) { formsMill = true; break; }
                                        }
                                    }

                                    if (formsMill) {
                                        auto removable = getRemovablePieces(player);
                                        for (const auto& removePos : removable) {
                                            vector<string> moveWithRemove = move;
                                            moveWithRemove.push_back(posToString(removePos));
                                            moves.push_back(moveWithRemove);
                                        }
                                    }
                                    else moves.push_back(move);
                                }
                            }
                        }
                    }
                }
            }
        }

        return moves;
    }

    // Эвристика
    int evaluate(int playerRoot) const {
        int score = 0;


        // Определим текущую фазу
        bool placing = phaseOfSet;


        // 1) Разница фишек
        score += (playerPieces[playerRoot] - playerPieces[1 - playerRoot]) * 100;


        // 2) Количество сформированных мельниц
        int millsCountRoot = 0, millsCountOpp = 0;
        for (const auto& mill : mills) {
            bool allRoot = true, allOpp = true;
            for (const auto& p : mill) {
                if (board[p.x][p.y] != getPlayerSymbol(playerRoot)) allRoot = false;
                if (board[p.x][p.y] != getPlayerSymbol(1 - playerRoot)) allOpp = false;
            }
            if (allRoot) millsCountRoot++;
            if (allOpp) millsCountOpp++;
        }
        score += (millsCountRoot - millsCountOpp) * 250;


        // 3) Близость к завершению мельницы (2 in row)
        int nearmillsRoot = 0, nearmillsOpp = 0;
        for (const auto& mill : mills) {
            int rcount = 0, ocount = 0, empt = 0;
            for (const auto& p : mill) {
                if (board[p.x][p.y] == getPlayerSymbol(playerRoot)) rcount++;
                else if (board[p.x][p.y] == getPlayerSymbol(1 - playerRoot)) ocount++;
                else if (board[p.x][p.y] == '.') empt++;
            }
            if (rcount == 2 && empt == 1) nearmillsRoot++;
            if (ocount == 2 && empt == 1) nearmillsOpp++;
        }
        score += nearmillsRoot * 80; //атака
        score -= nearmillsOpp * 120; // оборона


        // 4) Мобильность
        auto myMoves = getPossibleMoves(playerRoot);
        auto oppMoves = getPossibleMoves(1 - playerRoot);
        score += (int)myMoves.size() * 6;
        score -= (int)oppMoves.size() * 8;


        // 5) Контроль ключевых позиций
        vector<Position> keyPositions = { Position(3,1), Position(3,2), Position(3,4), Position(3,5), Position(1,3), Position(2,3), Position(4,3), Position(5,3) };
        for (const auto& pos : keyPositions) {
            if (board[pos.x][pos.y] == getPlayerSymbol(playerRoot)) score += 15;
            else if (board[pos.x][pos.y] == getPlayerSymbol(1 - playerRoot)) score -= 15;
        }


        return score;
    }

    // Вывод доски
    void printBoard() const {
        cout << "  a b c d e f g" << endl;
        for (int i = 0; i < 7; i++) {
            cout << i + 1 << " ";
            for (int j = 0; j < 7; j++) {
                if (board[i][j] == ' ') cout << "  ";
                else cout << board[i][j] << " ";
            }
            cout << endl;
        }
        cout << " --- STATE " << moveHistory.size() << " --- " << endl;
        cout << "Phase: " << (phaseOfSet ? "Placement" : "Movement") << endl;
        if (phaseOfSet)
            cout << "Player X: " << playerPieces[0] << " (hand: " << playerHand[0] << ") === Player O: " << playerPieces[1] << " (hand: " << playerHand[1] << ")" << endl;
        else
            cout << "Player X: " << playerPieces[0] << " === Player O: " << playerPieces[1] << endl;
        cout << "Current player: " << (getCurrentPlayer() == 0 ? "X" : "O") << endl;
    }

    // Получить копию игры
    MillGame copy() const { return *this; }

    void MillError(const string& msg) const { cout << "ERROR: " << msg << endl; }
};

//альфа-бета отсечение
class MillAI {
private:
    int maxDepth;
    std::mt19937 rng;

public:
    MillAI(int depth = 4) : maxDepth(depth) {
        rng.seed((unsigned)chrono::high_resolution_clock::now().time_since_epoch().count());
    }

    // Альфа-бета: rootPlayer игрок от лица которого считаем
    pair<vector<string>, int> alphaBeta(MillGame game, int depth, int alpha, int beta, int player, int rootPlayer,
        chrono::steady_clock::time_point startTime) {
        auto now = chrono::steady_clock::now();
        if (chrono::duration_cast<chrono::milliseconds>(now - startTime).count() > TIME_LIMIT_MS) {
            return make_pair(vector<string>(), game.evaluate(rootPlayer));
        }

        int gameOver = game.checkGameOver();
        if (depth == 0 || gameOver != -1) {
            int val = game.evaluate(rootPlayer);
            return make_pair(vector<string>(), val);
        }

        auto moves = game.getPossibleMoves(player);
        if (moves.empty()) return make_pair(vector<string>(), game.evaluate(rootPlayer));

        // Небольшой порядок ходов: оцениваем быстро каждый ход и сортируем
        vector<pair<int, vector<string>>> ordered;
        ordered.reserve(moves.size());
        for (auto m : moves) {
            MillGame ng = game.copy();
            if (!ng.makeMove(m, player)) continue;
            int quick = ng.evaluate(rootPlayer);
            ordered.push_back({ quick, m });
        }

        // Для максимизирующего игрока сортируем по убыванию
        bool isMax = (player == rootPlayer);
        sort(ordered.begin(), ordered.end(), [&](const auto& a, const auto& b) {
            return isMax ? (a.first > b.first) : (a.first < b.first);
            });

        vector<string> bestMove;
        int bestValue = isMax ? INT_MIN : INT_MAX;

        for (const auto& pr : ordered) {
            const auto& move = pr.second;

            MillGame newGame = game.copy();
            if (!newGame.makeMove(move, player)) continue;

            auto child = alphaBeta(newGame, depth - 1, alpha, beta, 1 - player, rootPlayer, startTime);
            int value = child.second;

            if (isMax) {
                if (value > bestValue) {
                    bestValue = value;
                    bestMove = move;
                }
                alpha = max(alpha, bestValue);
            }
            else {
                if (value < bestValue) {
                    bestValue = value;
                    bestMove = move;
                }
                beta = min(beta, bestValue);
            }

            if (alpha >= beta) break;

            now = chrono::steady_clock::now();
            if (chrono::duration_cast<chrono::milliseconds>(now - startTime).count() > TIME_LIMIT_MS) break;
        }

        // Если не найден ход — вернуть первый легальный
        if (bestMove.empty() && !ordered.empty()) bestMove = ordered.front().second;

        return make_pair(bestMove, bestValue);
    }

    // Итеративное углубление
    vector<string> findBestMove(MillGame& game, int player) {
        auto start = chrono::steady_clock::now();
        vector<string> best;
        for (int d = 1; d <= maxDepth; d++) {
            auto res = alphaBeta(game.copy(), d, INT_MIN, INT_MAX, player, player, start);
            if (!res.first.empty()) best = res.first;
            auto now = chrono::steady_clock::now();
            if (chrono::duration_cast<chrono::milliseconds>(now - start).count() > TIME_LIMIT_MS) break;
        }
        return best;
    }
};


MillGame game;
MillAI ai(5);

void playVsComputer(int humanPlayer) {
    int computerPlayer = 1 - humanPlayer;
    game.printBoard();

    if (computerPlayer == 0) {
        cout << "Computer plays as X - making first move" << endl;
        auto bestMove = ai.findBestMove(game, computerPlayer);
        string moveStr;
        for (const auto& part : bestMove) moveStr += part + " ";
        if (!moveStr.empty()) moveStr.pop_back();
        if (game.makeMove(bestMove, computerPlayer)) {
            cout << "Computer first move: " << moveStr << endl;
            game.printBoard();
        }
    }

    while (game.checkGameOver() == -1) {
        if (game.getCurrentPlayer() == humanPlayer) {
            cout << "Enter move: ";
            string input;
            getline(cin, input);
            if (input == "quit") break;
            vector<string> moveParts;
            stringstream ss(input);
            string part;
            while (ss >> part) moveParts.push_back(part);

            if (!moveParts.empty() && moveParts[0] == "u1") {
                if (game.undoMove()) cout << "Move undone" << endl;
                else cout << "Cannot undo move" << endl;
                continue;
            }

            if (game.makeMove(moveParts, humanPlayer)) game.printBoard();
            else { cout << "Invalid move. Try again." << endl; continue; }
        }
        else {
            cout << "Computer thinking..." << endl;
            auto bestMove = ai.findBestMove(game, computerPlayer);
            if (!bestMove.empty()) {
                string moveStr;
                for (const auto& part : bestMove) moveStr += part + " ";
                if (!moveStr.empty()) moveStr.pop_back();
                if (game.makeMove(bestMove, computerPlayer)) {
                    cout << "Computer move: " << moveStr << endl;
                    game.printBoard();
                }
            }
        }
    }

    int result = game.checkGameOver();
    if (result != -1) cout << "Game over! Winner: " << (result == 0 ? "X" : "O") << endl;
}

void runAsBot(int playerColor) {
    cerr.setf(std::ios::unitbuf);
    cout << "Bot started as player " << playerColor << " (" << (playerColor == 0 ? "X" : "O") << ")" << endl;

    if (playerColor == 0) {
        auto bestMove = ai.findBestMove(game, playerColor);
        string moveStr;
        for (const auto& part : bestMove) moveStr += part + " ";
        if (!moveStr.empty()) moveStr.pop_back();
        cerr << moveStr << endl;
        if (!game.makeMove(bestMove, playerColor)) cout << "Failed to apply my first move" << endl;
        game.printBoard();
    }

    string line;
    while (getline(cin, line)) {
        vector<string> opponentMove;
        stringstream ss(line);
        string part;
        while (ss >> part) opponentMove.push_back(part);

        cout << "Opponent move: " << line << endl;
        if (!opponentMove.empty() && opponentMove[0] != "u1") {
            if (!game.makeMove(opponentMove, 1 - playerColor)) cout << "Failed to apply opponent move" << endl;
        }
        else if (!opponentMove.empty() && opponentMove[0] == "u1") {
            game.undoMove();
        }
        game.printBoard();

        int gameResult = game.checkGameOver();
        if (gameResult != -1) {
            cout << "Game over after opponent move, result: " << gameResult << endl;
            if (gameResult == playerColor) exit(0);
            else if (gameResult == (1 - playerColor)) exit(3);
            else exit(4);
        }

        auto bestMove = ai.findBestMove(game, playerColor);
        string moveStr;
        for (const auto& part : bestMove) moveStr += part + " ";
        if (!moveStr.empty()) moveStr.pop_back();
        cerr << moveStr << endl;
        cout << "My move: " << moveStr << endl;
        if (!game.makeMove(bestMove, playerColor)) cout << "Failed to apply my move" << endl;
        game.printBoard();

        gameResult = game.checkGameOver();
        if (gameResult != -1) {
            cout << "Game over after my move, result: " << gameResult << endl;
            if (gameResult == playerColor) exit(0);
            else if (gameResult == (1 - playerColor)) exit(3);
            else exit(4);
        }
    }
}

int main(int argc, char* argv[]) {
    for (int i = 1; i < argc; i++) {
        string arg = argv[i];
        if (arg == "0" || arg == "1") {
            int playerColor = stoi(arg);
            runAsBot(playerColor);
            return 0;
        }
    }

    cout << "Mill Game - Human vs Computer" << endl;
    cout << "Choose your color (0 for X, 1 for O): ";
    string choice; getline(cin, choice);
    int humanPlayer = 0; if (choice == "1") humanPlayer = 1;
    cout << "You are playing as " << (humanPlayer == 0 ? "X" : "O") << endl;
    cout << "Commands: 'u1' to undo move, 'quit' to exit" << endl;

    playVsComputer(humanPlayer);
    return 0;
}
