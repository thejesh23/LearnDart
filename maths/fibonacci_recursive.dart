// Straight recursion — exponential time. Included for clarity, not speed.
int fibonacciRecursive(int n) {
  if (n < 0) throw ArgumentError('n must be non-negative');
  if (n < 2) return n;
  return fibonacciRecursive(n - 1) + fibonacciRecursive(n - 2);
}

void main() {
  for (int i = 0; i < 15; i++) {
    print('fib($i) = ${fibonacciRecursive(i)}');
  }
}
