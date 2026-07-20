// Enumerate the power set of a list — every 2^n possible subset,
// including the empty set and the full set.
//
// The recursion is a binary "include-or-skip" decision at each index:
// two recursive calls per element, giving 2^n leaves. Compare with
// bit_manipulation/power_set_via_bits.dart, which encodes the same
// choice as bits of an integer counter — often faster in practice and
// easier to parallelize, though this recursive shape is the clearest
// way to see the doubling recurrence.
//
// Complexity: O(n · 2^n) time and O(n · 2^n) space. Practical for
// n up to ~20; beyond that the output alone won't fit in memory.
List<List<T>> subsets<T>(List<T> items) {
  final result = <List<T>>[];
  void build(int i, List<T> current) {
    if (i == items.length) {
      result.add(List<T>.of(current));
      return;
    }
    build(i + 1, current);
    current.add(items[i]);
    build(i + 1, current);
    current.removeLast();
  }
  build(0, []);
  return result;
}

void main() {
  for (final s in subsets(['a', 'b', 'c'])) {
    print(s);
  }
}
