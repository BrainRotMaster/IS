#include <iostream>
#include <vector>
#include <string>
#include <algorithm>
#include <map>
#include <set>
#include <chrono>
#include <sstream>
#include <memory>

using namespace std;

// Константы времени
const int TIME_LIMIT_MS = 5000; // 4.9 секунды для безопасного завершения

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
    int playerPieces[2]; // Фишки на поле установленные [0] - текущий игрок, [1] - противник
    int playerHand[2];   // Фишки на руках
    bool phaseOfSet;     // true = фаза расстановки, false = фаза движения
    vector<vector<Position>> moveHistory;

    // Все возможные мельницы (тройки позиций)
    const vector<vector<Position>> mills = {
        // Горизонтальные мельницы
        {Position(0,0), Position(0,3), Position(0,6)},
        {Position(1,1), Position(1,3), Position(1,5)},
        {Position(2,2), Position(2,3), Position(2,4)},
        {Position(4,2), Position(4,3), Position(4,4)},
        {Position(5,1), Position(5,3), Position(5,5)},
        {Position(6,0), Position(6,3), Position(6,6)},

        {Position(3,0), Position(3,1), Position(3,2)},
        {Position(3,4), Position(3,5), Position(3,6)},
        // Вертикальные мельницы
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
    map<Position, vector<Position>> neighbors = {
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

public:
    MillGame() {
        // Инициализация пустой доски 7x7
        board = vector<vector<char>>(7, vector<char>(7, ' '));

        // Расстановка валидных позиций
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

        playerPieces[0] = playerPieces[1] = 0;
        playerHand[0] = playerHand[1] = 9;
        phaseOfSet = true;
    }

    // Конвертация координат из строкового формата
    Position stringToPos(const string& coord) {
        if (coord.length() != 2) return Position(-1, -1);
        char col = coord[0];
        char row = coord[1];

        int x = row - '1';
        int y = col - 'a';

        if (x < 0 || x >= 7 || y < 0 || y >= 7) return Position(-1, -1);
        return Position(x, y);
    }

    // Конвертация позиции в строковый формат
    string posToString(const Position& pos) {
        if (pos.x < 0 || pos.x >= 7 || pos.y < 0 || pos.y >= 7) return "";
        string result = "";
        result += char('a' + pos.y);
        result += char('1' + pos.x);
        return result;
    }

    // Проверка, является ли позиция валидной для игры
    bool isValidPosition(const Position& pos) {
        return board[pos.x][pos.y] != ' ';
    }

    // Получить символ игрока
    char getPlayerSymbol(int player) {
        return (player == 0) ? 'X' : 'O';
    }

    // Получить текущего игрока (0 или 1)
    int getCurrentPlayer() const {
        return moveHistory.size() % 2;
    }

    // Проверка образования мельницы для позиции
    vector<vector<Position>> checkMill(const Position& pos, int player) {
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
    vector<Position> getRemovablePieces(int player) {
        vector<Position> removable;
        char opponentSymbol = getPlayerSymbol(1 - player);

        // Сначала проверяем фишки, не входящие в мельницы
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

        // Если есть фишки не в мельницах, можно брать только их
        if (!notInMills.empty()) {
            return notInMills;
        }

        // Иначе можно брать любые фишки
        return inMills;
    }

    // Выполнение хода
    bool makeMove(const vector<string>& moveParts, int player) {
        if (moveParts.empty()) return false;

        // Отмена хода (для человека)
        if (moveParts[0] == "u1") {
            return undoMove();
        }

        vector<Position> currentMove;

        if (phaseOfSet) {
            // Фаза расстановки
            if (moveParts.size() < 1) return false;

            Position newPos = stringToPos(moveParts[0]);
            if (board[newPos.x][newPos.y] != '.') {
                return false;
            }

            // Устанавливаем фишку
            board[newPos.x][newPos.y] = getPlayerSymbol(player);
            playerHand[player]--;
            playerPieces[player]++;
            currentMove.push_back(newPos);

            // Проверяем образование мельницы
            auto millsFormed = checkMill(newPos, player);

            if (!millsFormed.empty()) {
                if ((moveParts.size() - 1) != millsFormed.size()) {
                    // Откатываем ход, если не указана фишка для взятия
                    /*MillError("parameters count != mills formed count (mills=" +
                        to_string(millsFormed.size()) + ", pars=" +
                        to_string(moveParts.size() - 1) + ")");*/
                    board[newPos.x][newPos.y] = '.';
                    playerHand[player]++;
                    playerPieces[player]--;
                    return false;
                }

                // Забираем фишку противника
                for (size_t i = 1; i < moveParts.size() && i <= millsFormed.size(); i++) {
                    Position removePos = stringToPos(moveParts[i]);
                    if (board[removePos.x][removePos.y] == getPlayerSymbol(1 - player)) {
                        board[removePos.x][removePos.y] = '.';
                        playerPieces[1 - player]--;
                        currentMove.push_back(removePos);
                    }
                    else {
                        // Откатываем ход при ошибке
                        MillError("incorrect parameter of removable piece");
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
            // Фаза движения
            if (moveParts.size() < 2) return false;

            Position fromPos = stringToPos(moveParts[0]);
            Position toPos = stringToPos(moveParts[1]);

            // Проверяем валидность хода
            if (board[fromPos.x][fromPos.y] != getPlayerSymbol(player) || board[toPos.x][toPos.y] != '.') {
                MillError("incorrect parameter of move (need X->empty)");
                return false;
            }

            // Проверяем, что позиции соседние
            auto& fromNeighbors = neighbors[fromPos];
            if (find(fromNeighbors.begin(), fromNeighbors.end(), toPos) == fromNeighbors.end()) {
                MillError("incorrect parameter of move (not neighbours)");
                return false;
            }

            // Выполняем движение
            board[fromPos.x][fromPos.y] = '.';
            board[toPos.x][toPos.y] = getPlayerSymbol(player);
            currentMove.push_back(fromPos);
            currentMove.push_back(toPos);

            // Проверяем образование мельницы
            auto millsFormed = checkMill(toPos, player);

            if (!millsFormed.empty()) {
                if (moveParts.size() < 3) {
                    // Откатываем ход
                    MillError("parameters count != mills formed count");
                    board[toPos.x][toPos.y] = '.';
                    board[fromPos.x][fromPos.y] = getPlayerSymbol(player);
                    return false;
                }

                // Забираем фишку противника
                for (size_t i = 2; i < moveParts.size() && i - 2 < millsFormed.size(); i++) {
                    Position removePos = stringToPos(moveParts[i]);
                    if (board[removePos.x][removePos.y] == getPlayerSymbol(1 - player)) {
                        board[removePos.x][removePos.y] = '.';
                        playerPieces[1 - player]--;
                        currentMove.push_back(removePos);
                    }
                    else {
                        // Откатываем ход
                        MillError("incorrect parameter of removable piece");
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

    // Отмена хода (только для человека, отменяет два последних хода - свой и противника)
    bool undoMove() {
        // Для отмены нужно как минимум 2 хода в истории (свой и противника)
        if (moveHistory.size() < 2) return false;

        // Отменяем два последних хода: сначала ход противника, потом свой
        for (int undoCount = 0; undoCount < 2; undoCount++) {
            // Получаем последний ход
            vector<Position> lastMove = moveHistory.back();
            moveHistory.pop_back();

            // Определяем игрока, который сделал этот ход
            int movePlayer = (moveHistory.size() % 2 == 0) ? 0 : 1; // 0 = X, 1 = O

            if (phaseOfSet) {
                // Фаза расстановки: первый элемент - установленная фишка
                Position placedPos = lastMove[0];

                // Восстанавливаем забираемые фишки противника (если были)
                for (size_t i = 1; i < lastMove.size(); i++) {
                    Position removedPos = lastMove[i];
                    // Восстанавливаем фишку на доске
                    board[removedPos.x][removedPos.y] = getPlayerSymbol(1 - movePlayer);
                    // Увеличиваем счетчик фишек противника
                    playerPieces[1 - movePlayer]++;
                }

                // Убираем установленную фишку
                board[placedPos.x][placedPos.y] = '.';
                playerHand[movePlayer]++;
                playerPieces[movePlayer]--;

            }
            else {
                // Фаза движения: первые два элемента - from и to
                Position fromPos = lastMove[0];
                Position toPos = lastMove[1];

                // Восстанавливаем забираемые фишки противника (если были)
                for (size_t i = 2; i < lastMove.size(); i++) {
                    Position removedPos = lastMove[i];
                    // Восстанавливаем фишку на доске
                    board[removedPos.x][removedPos.y] = getPlayerSymbol(1 - movePlayer);
                    // Увеличиваем счетчик фишек противника
                    playerPieces[1 - movePlayer]++;
                }

                // Отменяем движение: возвращаем фишку на исходную позицию
                board[toPos.x][toPos.y] = '.';
                board[fromPos.x][fromPos.y] = getPlayerSymbol(movePlayer);
            }

            // Проверяем, не вернулись ли мы в фазу расстановки
            if (!phaseOfSet && playerHand[0] > 0 || playerHand[1] > 0) {
                phaseOfSet = true;
            }
        }

        return true;
    }

    // Проверка окончания игры
    int checkGameOver() {
        if (!phaseOfSet) {
            // Проигрыш, если осталось 2 фишки
            if (playerPieces[0] <= 2) return 1; // Победил игрок 1
            if (playerPieces[1] <= 2) return 0; // Победил игрок 0
        }

        // Проверка на невозможность хода
        if (!phaseOfSet) {
            for (int player = 0; player < 2; player++) {
                bool canMove = false;
                for (int i = 0; i < 7 && !canMove; i++) {
                    for (int j = 0; j < 7 && !canMove; j++) {
                        if (board[i][j] == getPlayerSymbol(player)) {
                            Position pos(i, j);
                            auto& posNeighbors = neighbors[pos];
                            for (const auto& neighbor : posNeighbors) {
                                if (board[neighbor.x][neighbor.y] == '.') {
                                    canMove = true;
                                    break;
                                }
                            }
                        }
                    }
                }
                if (!canMove) return 1 - player;
            }
        }
        if (moveHistory.size() > 218) return 3; // ничья слишком много ходов 
        return -1; // Игра продолжается
    }

    // Получить все возможные ходы для игрока
    vector<vector<string>> getPossibleMoves(int player) {
        vector<vector<string>> moves;

        if (phaseOfSet) {
            // Все свободные позиции для установки
            for (int i = 0; i < 7; i++) {
                for (int j = 0; j < 7; j++) {
                    if (board[i][j] == '.') {
                        Position pos(i, j);
                        vector<string> move = { posToString(pos) };

                        // Проверяем, образуется ли мельница
                        board[i][j] = getPlayerSymbol(player);
                        auto millsFormed = checkMill(pos, player);
                        board[i][j] = '.';

                        if (!millsFormed.empty()) {//...............................................двойные мельницы добавить?
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
            // Все возможные движения
            for (int i = 0; i < 7; i++) {
                for (int j = 0; j < 7; j++) {
                    if (board[i][j] == getPlayerSymbol(player)) {
                        Position fromPos(i, j);
                        auto& fromNeighbors = neighbors[fromPos];

                        for (const auto& toPos : fromNeighbors) {
                            if (board[toPos.x][toPos.y] == '.') {
                                vector<string> move = {
                                    posToString(fromPos),
                                    posToString(toPos)
                                };

                                // Проверяем, образуется ли мельница
                                board[fromPos.x][fromPos.y] = '.';
                                board[toPos.x][toPos.y] = getPlayerSymbol(player);
                                auto millsFormed = checkMill(toPos, player);
                                board[toPos.x][toPos.y] = '.';
                                board[fromPos.x][fromPos.y] = getPlayerSymbol(player);

                                if (!millsFormed.empty()) {//...............................................двойные мельницы невозможны
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
            }
        }

        return moves;
    }

    // Эвристическая оценка позиции
    int evaluate(int player) {
        int score = 0;

        // 1. Баланс фишек (существующая логика)
        score += (playerPieces[player] - playerPieces[1 - player]) * 10;

        // 2. Потенциальные мельницы (нужно улучшить)
        int potentialMillsPlayer = 0;
        int potentialMillsOpponent = 0;

        for (const auto& mill : mills) {
            int playerCount = 0, opponentCount = 0, emptyCount = 0;

            for (const auto& pos : mill) {
                if (board[pos.x][pos.y] == getPlayerSymbol(player)) playerCount++;
                else if (board[pos.x][pos.y] == getPlayerSymbol(1 - player)) opponentCount++;
                else if (board[pos.x][pos.y] == '.') emptyCount++;
            }

            // ДОБАВИТЬ: разные веса для разных типов угроз
            if (playerCount == 2 && emptyCount == 1) {
                potentialMillsPlayer++;
                // ДОБАВИТЬ: дополнительный бонус если можно забрать фишку
                if (getRemovablePieces(player).size() > 0) {
                    score += 8; // Большой бонус за угрозу с захватом
                }
            }
            if (opponentCount == 2 && emptyCount == 1) {
                potentialMillsOpponent++;
                // ДОБАВИТЬ: штраф за угрозу противника
                score -= 7;
            }
        }

        score += potentialMillsPlayer * 5;
        score -= potentialMillsOpponent * 5;

        // 3. ДОБАВИТЬ: Контроль центра и ключевых позиций
        vector<Position> keyPositions = {
            Position(3,1), Position(3,2), Position(3,4), Position(3,5), // Центр
            Position(1,3), Position(2,3), Position(4,3), Position(5,3)  // Пересечения
        };

        for (const auto& pos : keyPositions) {
            if (board[pos.x][pos.y] == getPlayerSymbol(player)) score += 4;
            else if (board[pos.x][pos.y] == getPlayerSymbol(1 - player)) score -= 4;
        }

        // 4. ДОБАВИТЬ: Блокировка противника
        // Штрафовать ходы, которые дают противнику возможность создать мельницу
        int opponentThreats = 0;
        for (const auto& mill : mills) {
            int opponentCount = 0;
            for (const auto& pos : mill) {
                if (board[pos.x][pos.y] == getPlayerSymbol(1 - player)) opponentCount++;
            }
            if (opponentCount == 2) opponentThreats++;
        }
        score -= opponentThreats * 6;

        // 5. Подвижность (существующая логика)
        auto playerMoves = getPossibleMoves(player);
        auto opponentMoves = getPossibleMoves(1 - player);

        score += playerMoves.size() * 2;
        score -= opponentMoves.size() * 2;

        return score;
    }

    // Вывод доски
    void printBoard() {
        cout << "  a b c d e f g" << endl;
        for (int i = 0; i < 7; i++) {
            cout << i + 1 << " ";
            for (int j = 0; j < 7; j++) {
                if (board[i][j] == ' ') {
                    cout << "  ";
                }
                else {
                    cout << board[i][j] << " ";
                }
            }
            cout << endl;
        }
        cout << " --- STATE " << moveHistory.size() << " --- " << endl;
        cout << "Phase: " << (phaseOfSet ? "Placement" : "Movement") << endl;
        if (phaseOfSet)
            cout << "Player X: " << playerPieces[0] << " (hand: " << playerHand[0] << ") ========== Player O: " << playerPieces[1] << " (hand: " << playerHand[1] << ")" << endl;
        else
            cout << "Player X: " << playerPieces[0] << " ========== Player O: " << playerPieces[1] << endl;
        /*cout << "Player X: " << playerPieces[0] << " (hand: " << playerHand[0] << ")" << endl;
        cout << "Player O: " << playerPieces[1] << " (hand: " << playerHand[1] << ")" << endl;*/
        
        cout << "Current player: " << (getCurrentPlayer() == 0 ? "X" : "O") << endl;
    }

    // Получить копию игры
    MillGame copy() const {
        return *this;
    }

    void MillError(string msg) {
        cout << "ERROR: " << msg << endl;
    }
};

// Класс AI с альфа-бета отсечением
class MillAI {
private:
    int maxDepth;

public:
    MillAI(int depth = 4) : maxDepth(depth) {}

    // Алгоритм альфа-бета отсечения
    pair<vector<string>, int> alphaBeta(MillGame game, int depth, int alpha, int beta, int player,
        chrono::steady_clock::time_point startTime) {
        auto currentTime = chrono::steady_clock::now();
        auto elapsed = chrono::duration_cast<chrono::milliseconds>(currentTime - startTime);

        if (depth == 0 || elapsed.count() > TIME_LIMIT_MS || game.checkGameOver() != -1) {
            return make_pair(vector<string>(), game.evaluate(player));
        }

        auto moves = game.getPossibleMoves(player);
        if (moves.empty()) {
            return make_pair(vector<string>(), game.evaluate(player));
        }

        vector<string> bestMove;
        int bestValue = (player == 0) ? INT_MIN : INT_MAX;

        for (const auto& move : moves) {
            MillGame newGame = game.copy();
            if (!newGame.makeMove(move, player)) continue;

            auto result = alphaBeta(newGame, depth - 1, alpha, beta, 1 - player, startTime);
            int value = result.second;

            if (player == 0) { // Максимизирующий игрок
                if (value > bestValue) {
                    bestValue = value;
                    bestMove = move;
                    alpha = max(alpha, bestValue);
                }
            }
            else { // Минимизирующий игрок
                if (value < bestValue) {
                    bestValue = value;
                    bestMove = move;
                    beta = min(beta, bestValue);
                }
            }

            if (alpha >= beta) break;

            // Проверка времени
            currentTime = chrono::steady_clock::now();
            elapsed = chrono::duration_cast<chrono::milliseconds>(currentTime - startTime);
            if (elapsed.count() > TIME_LIMIT_MS) break;
        }

        return make_pair(bestMove, bestValue);
    }

    // Найти лучший ход
    vector<string> findBestMove(MillGame& game, int player) {
        auto startTime = chrono::steady_clock::now();
        auto result = alphaBeta(game, maxDepth, INT_MIN, INT_MAX, player, startTime);
        return result.first;
    }
};
///////////////////////////////////////////////////////проверить корректность алго

// Глобальные переменные для игры
MillGame game;
MillAI ai(5); // Глубина поиска

// Функция для игры с компьютером
void playVsComputer(int humanPlayer) {
    int computerPlayer = 1 - humanPlayer;
    game.printBoard();

    // Если компьютер играет крестиками - он ходит первым
    if (computerPlayer == 0) {
        cout << "Computer plays as X - making first move" << endl;

        // Ход компьютера
        auto bestMove = ai.findBestMove(game, computerPlayer);
        string moveStr;
        for (const auto& part : bestMove) {
            moveStr += part + " ";
        }

        if (game.makeMove(bestMove, computerPlayer)) {
            cout << "Computer first move: " << moveStr << endl;
            game.printBoard();
        }
    }

    while (game.checkGameOver() == -1) {
        if (game.getCurrentPlayer() == humanPlayer) {
            // Ход человека
            cout << "Enter move: ";
            string input;
            getline(cin, input);

            if (input == "quit") break;

            vector<string> moveParts;
            stringstream ss(input);
            string part;
            while (ss >> part) {
                moveParts.push_back(part);
            }

            if (!moveParts.empty() && moveParts[0] == "u1") {
                if (game.undoMove()) {
                    cout << "Move undone" << endl;
                }
                else {
                    cout << "Cannot undo move" << endl;
                }
                continue;
            }

            if (game.makeMove(moveParts, humanPlayer)) {
                game.printBoard();
            }
            else {
                cout << "Invalid move. Try again." << endl;
                continue;
            }
        }
        else {
            // Ход компьютера
            cout << "Computer thinking... ";
            auto bestMove = ai.findBestMove(game, computerPlayer);

            if (!bestMove.empty()) {
                string moveStr;
                for (const auto& part : bestMove) {
                    moveStr += part + " ";
                }

                if (game.makeMove(bestMove, computerPlayer)) {
                    cout << "Computer move: " << moveStr << endl;
                    game.printBoard();
                }
            }
        }
    }

    int result = game.checkGameOver();
    if (result != -1) {
        cout << "Game over! Winner: " << (result == 0 ? "X" : "O") << endl;
    }
}

// Функция для работы в режиме бота (для botctl)
void runAsBot(int playerColor) {
    cout << "Bot started as player " << playerColor << " (" << (playerColor == 0 ? "X" : "O") << ")" << endl;


    // Если играем крестиками - ходим первыми
    if (playerColor == 0) {
        cout << "I play as X - making first move" << endl;

        // Находим и делаем первый ход
        auto bestMove = ai.findBestMove(game, playerColor);
        string moveStr;
        for (const auto& part : bestMove) {
            moveStr += part + " ";
        }
        if (!moveStr.empty()) {
            moveStr.pop_back();
        }

        cout << "My first move: " << moveStr << endl;

        // Применяем свой ход
        if (!game.makeMove(bestMove, playerColor)) {
            cout << "Failed to apply my first move" << endl;
        }

        // Выводим состояние доски
        cout << "Board after first move:" << endl;
        game.printBoard();

        // Выводим ход в stderr (ТОЛЬКО ХОД, без лишней информации)
        cerr << moveStr << endl;
    }


    string line;
    while (getline(cin, line)) {
        

        // Парсинг хода противника
        vector<string> opponentMove;
        stringstream ss(line);
        string part;
        while (ss >> part) {
            opponentMove.push_back(part);
        }

        cout << "Opponent move: " << line << endl;

        // Применяем ход противника (если это не отмена хода)
        if (!opponentMove.empty() && opponentMove[0] != "u1") {
            if (!game.makeMove(opponentMove, 1 - playerColor)) {
                cout << "Failed to apply opponent move" << endl;
            }

        }
        game.printBoard();

        // Проверяем окончание игры после хода противника
        int gameResult = game.checkGameOver();
        if (gameResult != -1) {
            cout << "Game over after opponent move, result: " << gameResult << endl;
            if (gameResult == playerColor) {
                exit(0); // Победа
            }
            else if (gameResult == (1 - playerColor)) {
                exit(3); // Поражение
            }
            else {
                exit(4); // Ничья
            }
        }

        // Находим и делаем ответный ход
        auto bestMove = ai.findBestMove(game, playerColor);
        string moveStr;
        for (const auto& part : bestMove) {
            moveStr += part + " ";
        }
        if (!moveStr.empty()) {
            moveStr.pop_back();
        }

        // Выводим ход в stderr (ТОЛЬКО ХОД, без лишней информации)
        cerr << moveStr << endl;
        cout << "My move: " << moveStr << endl;

        // Применяем свой ход
        if (!game.makeMove(bestMove, playerColor)) {
            cout << "Failed to apply my move" << endl;
        }
        game.printBoard();

        // Проверяем окончание игры после своего хода
        gameResult = game.checkGameOver();
        if (gameResult != -1) {
            cout << "Game over after my move, result: " << gameResult << endl;
            if (gameResult == playerColor) {
                exit(0); // Победа
            }
            else if (gameResult == (1 - playerColor)) {
                exit(3); // Поражение
            }
            else {
                exit(4); // Ничья
            }
        }
    }
}

int main(int argc, char* argv[]) {
    // Режим бота для botctl
    for (int i = 1; i < argc; i++) {
        string arg = argv[i];
        if (arg == "0" || arg == "1") {
            int playerColor = stoi(arg);
            runAsBot(playerColor);
            return 0;
        }
    }

    // Режим игры человек vs компьютер
    cout << "Mill Game - Human vs Computer" << endl;
    cout << "Choose your color (0 for X, 1 for O): ";
    string choice;
    getline(cin, choice);

    int humanPlayer = 0; // X по умолчанию
    if (choice == "1") {
        humanPlayer = 1;
    }

    cout << "You are playing as " << (humanPlayer == 0 ? "X" : "O") << endl;
    cout << "Commands: 'u1' to undo move, 'quit' to exit" << endl;

    playVsComputer(humanPlayer);

    return 0;
}