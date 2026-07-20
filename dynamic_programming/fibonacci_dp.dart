// Fibonacci via bottom-up dynamic programming: fill an array in order,
// each entry the sum of its two predecessors. O(n) time, O(n) space.
//
// This tabulated form is what "DP" traditionally meant — an iterative
// pass through a table. The equivalent top-down approach (memoized
// recursion) lives in maths/fibonacci_memoized.dart. Two mental
// pictures of the same computation:
//   - top-down: recursion + cache, computes only what's needed
//   - bottom-up: iteration + table, computes everything up to n
// Both O(n); pick whichever fits the shape of the sub-problem graph.
//
// The O(1)-space rolling-window variant is at
// maths/fibonacci_iterative.dart — same asymptotic time, tiny memory.
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
