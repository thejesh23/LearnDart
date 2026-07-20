// LSD (Least Significant Digit) radix sort for non-negative integers.
// Runs a stable counting sort on each decimal digit from lowest to
// highest; because each pass is stable, the final ordering respects
// the earlier passes.
//
// A non-comparison sort — the O(n log n) lower bound doesn't apply.
// Runs in O(d · n) time where d is the number of digits, so it's
// effectively linear for fixed-width integer keys. Wins over the
// O(n log n) comparison sorts once n is large enough that d · c1 <
// log n · c2 for the constants.
//
// Base 10 is chosen here for readability; production radix sorts use
// base 2^8 or 2^16 for cache-friendly buckets. Not comparison-based,
// so it doesn't work directly on arbitrary types — needs an
// ordinal encoding. Complexity: O(d · n) time, O(n + k) space.
List<int> radixSort(List<int> input) {
  if (input.isEmpty) return [];
  final a = List<int>.of(input);
  final max = a.reduce((x, y) => x > y ? x : y);
  int exp = 1;
  while (max ~/ exp > 0) {
    _countingSortByDigit(a, exp);
    exp *= 10;
  }
  return a;
}

void _countingSortByDigit(List<int> a, int exp) {
  final n = a.length;
  final output = List<int>.filled(n, 0);
  final count = List<int>.filled(10, 0);
  for (final v in a) count[(v ~/ exp) % 10]++;
  for (int i = 1; i < 10; i++) count[i] += count[i - 1];
  for (int i = n - 1; i >= 0; i--) {
    final d = (a[i] ~/ exp) % 10;
    output[--count[d]] = a[i];
  }
  for (int i = 0; i < n; i++) a[i] = output[i];
}

void main() {
  print(radixSort([170, 45, 75, 90, 802, 24, 2, 66]));
}
