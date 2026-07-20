// Fibonacci with memoization: same recursive structure as the naive
// version, but cache results by index so each subproblem is only
// computed once.
//
// The transformation from naive recursion to memoized recursion is
// the canonical entry to dynamic programming. The recurrence stays
// exactly the same; only the caching changes the complexity — O(2^n)
// becomes O(n), the enabling insight for whole DP problem categories.
//
// Uses BigInt because Fibonacci grows so fast that n = 92 overflows
// 63-bit ints. The cache is a top-level `Map<int, BigInt>` seeded
// with base cases; subsequent runs benefit from prior computations.
// See dynamic_programming/fibonacci_dp.dart for the bottom-up
// tabulated equivalent.
final Map<int, BigInt> _cache = {0: BigInt.zero, 1: BigInt.one};

BigInt fibonacciMemoized(int n) {
  if (n < 0) throw ArgumentError('n must be non-negative');
  final cached = _cache[n];
  if (cached != null) return cached;
  final v = fibonacciMemoized(n - 1) + fibonacciMemoized(n - 2);
  _cache[n] = v;
  return v;
}

void main() {
  for (final i in [10, 20, 50, 100]) {
    print('fib($i) = ${fibonacciMemoized(i)}');
  }
}
