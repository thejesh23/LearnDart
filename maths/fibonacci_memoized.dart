// Recursion with memoization — reduces from exponential to linear.
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
