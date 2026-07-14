// Bottom-up tabulated Fibonacci — O(n) time, O(n) space. See
// maths/fibonacci_iterative.dart for the O(1)-space variant.
BigInt fibonacciDP(int n) {
  if (n < 0) throw ArgumentError('n must be non-negative');
  final table = List<BigInt>.filled(n + 1, BigInt.zero);
  if (n >= 1) table[1] = BigInt.one;
  for (int i = 2; i <= n; i++) {
    table[i] = table[i - 1] + table[i - 2];
  }
  return table[n];
}

void main() {
  for (final i in [10, 50, 100]) {
    print('fib($i) = ${fibonacciDP(i)}');
  }
}
