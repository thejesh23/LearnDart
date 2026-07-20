// Enumerate every combination of `candidates` — each candidate usable
// unlimited times — that sums to `target`.
//
// Two tricks avoid duplicate outputs:
//   1. Sort candidates ascending, then break when a candidate exceeds
//      the remaining target. That's pure pruning — no wasted branches
//      exploring larger-than-needed values.
//   2. Recurse with the same start index `i` (not `i + 1`) so the same
//      candidate can be reused, but never step *backward* — this
//      canonicalizes each combination to non-decreasing order and
//      guarantees each unique combination is produced exactly once.
//
// Complexity: exponential in the worst case. Related: subset_sum.dart
// uses each element at most once instead of unlimited times.
List<List<int>> combinationSum(List<int> candidates, int target) {
  final sorted = List<int>.of(candidates)..sort();
  final results = <List<int>>[];
  final current = <int>[];

  void choose(int start, int remaining) {
    if (remaining == 0) {
      results.add(List<int>.of(current));
      return;
    }
    for (int i = start; i < sorted.length; i++) {
      if (sorted[i] > remaining) break;
      current.add(sorted[i]);
      choose(i, remaining - sorted[i]);
      current.removeLast();
    }
  }

  choose(0, target);
  return results;
}

void main() {
  print(combinationSum([2, 3, 6, 7], 7));   // [[2,2,3], [7]]
  print(combinationSum([2, 3, 5], 8));      // [[2,2,2,2], [2,3,3], [3,5]]
}
