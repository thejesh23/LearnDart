// Recursive ternary search on a sorted list.
int ternarySearchRecursive(List<int> sorted, int target,
    [int? lo, int? hi]) {
  lo ??= 0;
  hi ??= sorted.length - 1;
  if (lo > hi) return -1;
  final third = (hi - lo) ~/ 3;
  final m1 = lo + third;
  final m2 = hi - third;
  if (sorted[m1] == target) return m1;
  if (sorted[m2] == target) return m2;
  if (target < sorted[m1]) {
    return ternarySearchRecursive(sorted, target, lo, m1 - 1);
  }
  if (target > sorted[m2]) {
    return ternarySearchRecursive(sorted, target, m2 + 1, hi);
  }
  return ternarySearchRecursive(sorted, target, m1 + 1, m2 - 1);
}

void main() {
  final data = [1, 3, 5, 7, 9, 11, 13, 15, 17];
  print(ternarySearchRecursive(data, 11));
  print(ternarySearchRecursive(data, 4));
}
