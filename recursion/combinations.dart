// Generate every k-element subset (combination) of `items` — unlike
// permutations, order doesn't matter and duplicates aren't produced.
//
// The recursion is "either the first element is in the subset (then
// pick k-1 more from the tail) or it isn't (then pick k from the tail)".
// This structure guarantees that each combination is produced exactly
// once and that outputs come out in lexicographic order.
//
// Complexity: C(n, k) results, each of length k, so total work is
// O(k · C(n, k)). See maths/binomial_coefficient.dart for computing
// just the count, and recursion/subset_generation.dart for all subsets
// of all sizes.
List<List<T>> combinations<T>(List<T> items, int k) {
  if (k == 0) return [<T>[]];
  if (items.length < k) return const [];
  final out = <List<T>>[];
  for (int i = 0; i <= items.length - k; i++) {
    final head = items[i];
    for (final tail in combinations(items.sublist(i + 1), k - 1)) {
      out.add([head, ...tail]);
    }
  }
  return out;
}

void main() {
  for (final c in combinations([1, 2, 3, 4], 2)) {
    print(c);
  }
}
