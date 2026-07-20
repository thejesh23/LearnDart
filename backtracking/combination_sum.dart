// Find every combination of `candidates` (each usable any number of
// times) that sums to `target`. Duplicates in output are avoided by
// only ever recursing on the same-or-later index.
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
