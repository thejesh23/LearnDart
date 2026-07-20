// nth Fibonacci number via a two-variable iterative loop. F(0) = 0,
// F(1) = 1, F(n) = F(n-1) + F(n-2).
//
// O(n) time and O(1) space — the two-variable trick is what makes
// this the standard way to compute Fibonacci in production. Compare:
//   maths/fibonacci_recursive.dart  — O(2^n), for teaching
//   maths/fibonacci_memoized.dart   — O(n) time and space
//   dynamic_programming/fibonacci_dp.dart — same asymptotic, tabulated
//
// For very large n (thousands of digits), matrix exponentiation gives
// O(log n) with big-int multiplications. Note: this int-returning
// version overflows silently around n = 92 for Dart's 63-bit ints;
// switch to BigInt for higher n.

int fibonacci(int n) {
  if (n < 0) throw ArgumentError('n must be non-negative');
  if (n < 2) return n;
  int a = 0, b = 1;
  for (int i = 2; i <= n; i++) {
    final c = a + b;
    a = b;
    b = c;
  }
  return b;
}

void main() {
  for (int i = 0; i < 15; i++) {
    print('fib($i) = ${fibonacci(i)}');
  }
}
