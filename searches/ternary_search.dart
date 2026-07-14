// Ternary search on a sorted list — splits into thirds instead of halves.
int ternarySearch(List<int> sorted, int target) {
  int lo = 0;
  int hi = sorted.length - 1;
  while (lo <= hi) {
    final third = (hi - lo) ~/ 3;
    final m1 = lo + third;
    final m2 = hi - third;
    if (sorted[m1] == target) return m1;
    if (sorted[m2] == target) return m2;
    if (target < sorted[m1]) {
      hi = m1 - 1;
    } else if (target > sorted[m2]) {
      lo = m2 + 1;
    } else {
      lo = m1 + 1;
      hi = m2 - 1;
    }
  }
  return -1;
}

void main() {
  final data = [1, 3, 5, 7, 9, 11, 13, 15, 17];
  print(ternarySearch(data, 11));
  print(ternarySearch(data, 4));
}
