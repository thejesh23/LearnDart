import 'dart:math';

int jumpSearch(List<int> sorted, int target) {
  final n = sorted.length;
  if (n == 0) return -1;
  int step = sqrt(n).floor();
  int prev = 0;
  while (prev < n && sorted[min(step, n) - 1] < target) {
    prev = step;
    step += sqrt(n).floor();
    if (prev >= n) return -1;
  }
  for (int i = prev; i < min(step, n); i++) {
    if (sorted[i] == target) return i;
  }
  return -1;
}

void main() {
  final data = List<int>.generate(20, (i) => i * 2); // 0, 2, 4, ... 38
  print(jumpSearch(data, 18));
  print(jumpSearch(data, 15));
}
