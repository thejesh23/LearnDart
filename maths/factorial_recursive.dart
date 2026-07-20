// Recursive factorial: n! = n · (n-1)!.
//
// The recursion depth is O(n), so a Dart stack overflow occurs around
// n ~= 10^4 in practice. For anything large, the iterative form
// (maths/factorial_iterative.dart) is safer.
//
// Included alongside the iterative version as a classic side-by-side
// contrast: iterative shows how the computation runs; recursive
// captures the mathematical *definition* directly. Both use BigInt
// because factorials outgrow machine integers by n = 21.

BigInt factorialRecursive(int n) {
  if (n < 0) throw ArgumentError('n must be non-negative');
  if (n <= 1) return BigInt.one;
  return BigInt.from(n) * factorialRecursive(n - 1);
}

void main() {
  for (final n in [0, 1, 5, 10, 25]) {
    print('$n! = ${factorialRecursive(n)}');
  }
}
