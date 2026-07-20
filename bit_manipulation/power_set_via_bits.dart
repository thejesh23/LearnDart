// Enumerate the power set of `items` using a binary counter. Each of
// the 2^n integers from 0 to 2^n - 1 has a unique bit pattern; treat
// bit i of that pattern as "include items[i] in this subset".
//
// Contrast with recursion/subset_generation.dart, which uses recursion
// to make the include/skip decision. The bit-counter form is often
// faster in practice (no call overhead), easier to parallelize, and
// trivial to make lazy — replace the outer `for` with a `sync*` that
// yields one subset at a time.
//
// Practical limit: n up to ~20-25 depending on what you do with each
// subset. Beyond ~64 the mask itself won't fit in an int; you'd need
// a BigInt counter or bitwise operations over multi-word arrays.
// Complexity: O(n · 2^n) time, O(n · 2^n) space.
List<List<T>> powerSet<T>(List<T> items) {
  final n = items.length;
  final total = 1 << n;
  final result = <List<T>>[];
  for (int mask = 0; mask < total; mask++) {
    final subset = <T>[];
    for (int i = 0; i < n; i++) {
      if ((mask >> i) & 1 == 1) subset.add(items[i]);
    }
    result.add(subset);
  }
  return result;
}

void main() {
  for (final s in powerSet(['a', 'b', 'c'])) {
    print(s);
  }
}
