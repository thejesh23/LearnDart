// Naive recursive Fibonacci: F(n) = F(n-1) + F(n-2).
//
// Included as the canonical example of exponential-time recursion. The
// recursion tree for F(n) has ~F(n) leaves — computing F(40) triggers
// roughly 165 million calls, most of them redundant subproblems. F(60)
// runs for years.
//
// The fix — memoization — turns it O(n): see
// maths/fibonacci_memoized.dart. That transformation is the whole
// pedagogical point of the classic recursion → DP progression.
//
// For any real use, prefer the iterative form
// (maths/fibonacci_iterative.dart). This file exists to prove why.
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
