// LSD radix sort for non-negative integers.
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
