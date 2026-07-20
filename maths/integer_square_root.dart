// Integer square root: floor(√n) computed entirely in integer
// arithmetic, no floating-point involved.
//
// Newton's method on f(x) = x² - n gives the iteration
// x ← (x + n/x) / 2. Each step roughly doubles the number of correct
// digits (quadratic convergence), so ~log log n iterations suffice.
// The `y < x` loop guard stops as soon as we start increasing again
// — that's the floor.
//
// Why not `sqrt(n).floor()`? Because for n ≥ 2^53, doubles can't
// represent n exactly and `sqrt` returns something a bit off. This
// int-only version is exact for the full 64-bit range.
//
// Complexity: O(log log n) iterations, each doing arithmetic on
// numbers with O(log n) bits.
int integerSqrt(int n) {
  if (n < 0) throw ArgumentError('n must be non-negative');
  if (n < 2) return n;
  int x = n;
  int y = (x + 1) ~/ 2;
  while (y < x) {
    x = y;
    y = (x + n ~/ x) ~/ 2;
  }
  return x;
}

void main() {
  for (final n in [0, 1, 2, 8, 9, 15, 16, 25, 1_000_000, 999_999_999_999]) {
    print('isqrt($n) = ${integerSqrt(n)}');
  }
}
