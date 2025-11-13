//Решить вводные задачи поиска :
//
//1. Даны два целых числа – например, 2 и 100, а также две операции – «прибавить 3» и «умножить на 2».Найти минимальную последовательность операций, позволяющую получить из первого числа второе.
//2. То же самое, что и в пункте 1, однако добавляется операция «вычесть 2».
//3. Реализовать задание из пункта 1 методом обратного поиска – от целевого состояния к начальному.Сравнить эффективность.
//4. Дополнительное задание.Реализовать метод двунаправленного поиска для решения задачи из пункта 1.


#include <iostream>
#include <vector>
#include <queue>
#include <chrono>

using namespace std;
using namespace std::chrono;

vector<int> task1(int a, int b) {
	queue<int> q;
	vector<int> result(b + 1, -1);
	vector<bool> visited(b + 1);
	q.push(a);
	visited[a] = true;
	while (!q.empty()) {
		int cur = q.front();
		q.pop();
		if (cur == b) break;
		if (cur + 3 <= b && !visited[cur + 3]) {
			visited[cur + 3] = true;
			q.push(cur + 3);
			result[cur + 3] = cur;
		}
		if (cur * 2 <= b && !visited[cur * 2]) {
			visited[cur * 2] = true;
			q.push(cur * 2);
			result[cur * 2] = cur;
		}
	}
	return result;
}

void print(int a, int b, vector<int>(*func)(int, int)) {
	cout << a << " -> " << b << endl;
	auto start = steady_clock::now();
	vector<int> vec = func(a, b);
	auto end = steady_clock::now();
	int count = 0;
	int cur = b;
	if (vec[b] != -1) {
		while (cur != a) {
			cur = vec[cur];
			if (cur == -1) {
				count = 0;
				break;
			}
			count++;
		}
	}
	auto ms = duration_cast<microseconds>(end - start).count();
	cout << "count operation=" << count << endl;
	cout << "Time: " << ms / 1000.0 << " ms" << endl;
}

vector<int> task2(int a, int b) {
	int left = 0;
	int right = b * 2 + 16;
	int n = right - left + 1;
	auto inRange = [&](int x) { return x >= left && x <= right; };

	vector<int> result(n, -1);
	vector<bool> visited(n, false);
	queue<int> q;

	q.push(a);
	visited[a] = true;

	while (!q.empty()) {
		int cur = q.front();
		q.pop();
		int sw1 = cur + 3;
		int sw2 = cur * 2;
		int sw3 = cur - 2;
		if (cur == b) break;
		if (inRange(sw1) && !visited[sw1]) {
			visited[sw1] = true;
			q.push(sw1);
			result[sw1] = cur;
		}
		if (inRange(sw2) && !visited[sw2]) {
			visited[sw2] = true;
			q.push(sw2);
			result[sw2] = cur;
		}
		if (inRange(sw3) && !visited[sw3]) {
			visited[sw3] = true;
			q.push(sw3);
			result[sw3] = cur;
		}
	}
	return result;
}

vector<int> task3(int a, int b) {
	queue<int> q;
	vector<int>result(b + 1, -1);
	vector<bool>visited(b + 1);
	visited[b] = true;
	q.push(b);
	while (!q.empty()) {
		int current = q.front();
		q.pop();
		if (current - 3 >= 0 && !visited[current - 3]) {
			q.push(current - 3);
			visited[current - 3] = true;
			result[current - 3] = current;
		}
		if (current % 2 == 0 && current / 2 >= 0 && !visited[current / 2]) {
			q.push(current / 2);
			visited[current / 2] = true;
			result[current / 2] = current;
		}
		if (current == a) break;
	}
	vector<int> realRes(b + 1, -1); //reverse
	if (a <= b && result[a] != -1) {
		for (int cur = a; cur != b; cur = result[cur]) {
			int par = result[cur];
			if (par == -1) break;
			realRes[par] = cur;
		}
	}

	return realRes;
}

vector<int> task4(int a, int b) {
	queue<int> q1;
	q1.push(a);
	vector<int>result1(b + 1, -1);
	vector<bool>visited1(b + 1);
	visited1[a] = true;

	queue<int> q2;
	q2.push(b);
	vector<int>result2(b + 1, -1);
	vector<bool>visited2(b + 1);
	visited2[b] = true;

	int middle = -1;

	while (!q1.empty() && !q2.empty() && middle == -1) {
		int qs = q1.size();
		while (qs-- && middle == -1) {
			int cur1 = q1.front();
			q1.pop();
			for (int nx : {cur1 + 3, cur1 * 2}) {
				if (nx <= b && !visited1[nx]) {
					visited1[nx] = true;
					result1[nx] = cur1;
					q1.push(nx);
					if (visited2[nx]) { middle = nx; break; }
				}
			}
		}

		qs = q2.size();
		while (qs-- && middle == -1) {
			int cur2 = q2.front(); 
			q2.pop();
			for (int nx : {cur2 - 3, (cur2 % 2 == 0 ? cur2 / 2 : -1)}) {
				if (nx >= 0 && !visited2[nx]) {
					visited2[nx] = true;
					result2[nx] = cur2;
					q2.push(nx);
					if (visited1[nx]) { middle = nx; break; }
				}
			}
		}
	}

	if (middle == -1) return vector<int>(b + 1, -1);

	vector<int>left;
	for (int cur = middle; cur != -1; cur = result1[cur]) left.push_back(cur);
	//for (int i = 0; i < left.size(); i++) {
	//	cout << left[i] << " - ";
	//}
	reverse(left.begin(), left.end());

	if (left.empty() || left.front() != a) return vector<int>(b + 1, -1);

	vector<int>right;
	for (int cur = result2[middle]; cur != -1; cur = result2[cur]) right.push_back(cur);

	vector<int> full = left;
	full.insert(full.end(), right.begin(), right.end());

	vector<int> parentDown(b + 1, -1);
	for (int i = 1; i < full.size(); i++) {
		int prev = full[i - 1];
		int cur = full[i];
		parentDown[cur] = prev;
	}
	return parentDown;
}

int main()
{
	int a = 2;
	int b = 10000001;
	cout << "---Task1---" << endl;
	print(a, b, task1);
	cout << "---Task2---" << endl;
	print(a, b, task2);
	cout << "---Task3---" << endl;
	print(a, b, task3);
	cout << "---Task4---" << endl;
	print(a, b, task4);
}
