// Stirling's approximation for n! — a fast closed form for large
// factorials where the exact integer would overflow or be too
// slow to compute directly.
//
// Basic Stirling:  n! ≈ √(2πn) · (n/e)^n
// Ramanujan (much tighter):
//    n! ≈ √π · (n/e)^n · (8n³ + 4n² + n + 1/30)^(1/6)
//
// Ramanujan's form has ~10⁻⁷ relative error even for small n (~5),
// while basic Stirling's error is ~1/(12n). Use these when you
// need log(n!) for combinatorial problems (e.g. binomial in
// maths/binomial_coefficient.dart at gigantic n), or when you just
// need magnitude and can't afford BigInt.
//
// See also maths/factorial_iterative.dart / factorial_recursive.dart
// for the exact-integer versions.
import 'dart:math';

double stirling(double n) {
  if (n < 0) throw ArgumentError('n must be ≥ 0');
  if (n == 0) return 1.0;
  return sqrt(2 * pi * n) * pow(n / e, n).toDouble();
}

double ramanujanFactorial(double n) {
  if (n < 0) throw ArgumentError('n must be ≥ 0');
  if (n == 0) return 1.0;
  return sqrt(pi) *
      pow(n / e, n).toDouble() *
      pow(8 * n * n * n + 4 * n * n + n + 1 / 30, 1 / 6).toDouble();
}

void main() {
  for (int i = 1; i <= 10; i++) {
    print('$i!  stirling ≈ ${stirling(i.toDouble()).toStringAsFixed(2)}   '
          'ramanujan ≈ ${ramanujanFactorial(i.toDouble()).toStringAsFixed(2)}');
  }
  // 100! is ~9.33e157 — well beyond int64 but Stirling gives it instantly.
  print('100! ≈ ${stirling(100).toStringAsExponential(4)}');
}
