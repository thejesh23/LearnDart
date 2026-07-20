// Recursive ternary search. The recursion mirrors the iterative
// version's four-way branch (found m1, found m2, target below m1,
// target above m2, target in between) — each else-if returns a
// tail-shaped recursive call.
//
// See searches/ternary_search.dart for the iterative form and the
// discussion of why ternary search isn't actually faster than binary
// search on a sorted array. Complexity: O(log n) time; recursion
// depth is also O(log n), so stack usage is negligible.
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
