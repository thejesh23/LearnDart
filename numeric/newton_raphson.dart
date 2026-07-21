// Newton-Raphson Method — quadratically convergent root finding.
// Isaac Newton described it in 1669 (for polynomials); Joseph Raphson
// published the general form in 1690.  Still indispensable today in:
//   • Floating-point hardware: sqrt, reciprocal, division circuits.
//   • Machine learning: second-order optimisation (L-BFGS, Newton-CG).
//   • Computational finance: implied volatility solvers.
//   • Matrix computation: computing matrix inverses, polar decomposition.
//
// The iteration:  x_{n+1} = x_n - f(x_n) / f'(x_n)
//
// Geometric intuition: at x_n, draw the tangent line to f.  The next
// guess is where that tangent crosses the x-axis.  Near a simple root,
// the error squares each iteration (quadratic convergence): if you have
// k correct digits, the next step gives ~2k correct digits.
//
// sqrt(n): solve f(x) = x² - n = 0, f'(x) = 2x.
//   x_{n+1} = x_n - (x_n² - n) / (2x_n) = (x_n + n/x_n) / 2
//   (Babylonian method, known since ~2000 BC)
//
// Reciprocal 1/d without division: solve f(x) = 1/x - d = 0.
//   x_{n+1} = x_n(2 - d·x_n)
//   Used in fast reciprocal sqrt (the Quake III "magic number" trick).
//
// Complexity: O(log(1/ε)) iterations for tolerance ε; each iteration
// is O(1) arithmetic ops (for these scalar applications).
//
// Run:  dart run numeric/newton_raphson.dart
import 'dart:math' as math;

// --- generic Newton-Raphson -------------------------------------------

double newtonRaphson(
  double Function(double) f,
  double Function(double) fPrime,
  double x0, {
  double tol = 1e-12,
  int maxIter = 100,
}) {
  double x = x0;
  for (int i = 0; i < maxIter; i++) {
    final fx = f(x);
    if (fx.abs() < tol) return x;
    x -= fx / fPrime(x);
  }
  return x;
}

// --- sqrt via Babylonian / Newton-Raphson ----------------------------

double sqrtNewton(double n, {bool trace = false}) {
  if (n < 0) throw ArgumentError('sqrt of negative number');
  if (n == 0) return 0;
  double x = n > 1 ? n / 2 : 1.0;  // initial guess
  if (trace) print('  Iteration trace for sqrt($n):');
  for (int i = 0; i < 60; i++) {
    final next = (x + n / x) / 2;
    if (trace) {
      final err = (next - math.sqrt(n)).abs();
      print('    iter ${i.toString().padLeft(2)}: x = ${next.toStringAsFixed(15)}'
          '  error = ${err.toStringAsExponential(3)}');
    }
    if ((next - x).abs() < 1e-15 * x) return next;
    x = next;
  }
  return x;
}

// --- reciprocal 1/d without division ---------------------------------

double reciprocalNewton(double d) {
  // Initial guess: 1.0 / d — but we can also use a bit-trick approximation.
  // For demo purposes, start from a rough approximation.
  double x = 1.0 / (d.abs() + 1.0) * (d > 0 ? 1 : -1);
  // x_{n+1} = x_n × (2 - d × x_n)
  for (int i = 0; i < 60; i++) {
    final next = x * (2 - d * x);
    if ((next - x).abs() < 1e-15) return next;
    x = next;
  }
  return x;
}

// --- demo --------------------------------------------------------------

void main() {
  print('=== Newton-Raphson Root Finding ===\n');

  // --- sqrt(2) with convergence trace ---
  print('sqrt(2) starting from x₀=1.0 (Babylonian method):');
  final s2 = sqrtNewton(2, trace: true);
  print('  Result   : $s2');
  print('  dart:math: ${math.sqrt(2)}');
  print('  Error    : ${(s2 - math.sqrt(2)).abs().toStringAsExponential(3)}\n');

  // --- sqrt from bad starting point ---
  print('sqrt(16384) starting from x₀=8192 (terrible guess):');
  final sw = Stopwatch()..start();
  final s3 = sqrtNewton(16384, trace: false); sw.stop();
  print('  Result   : $s3');
  print('  Expected : ${math.sqrt(16384)}');
  print('  Error    : ${(s3 - math.sqrt(16384)).abs().toStringAsExponential(3)}');
  print('  Time     : ${sw.elapsedMicroseconds} µs\n');

  // --- generic Newton for cube root ---
  print('Cube root of 27 via generic Newton-Raphson:');
  final cbrt27 = newtonRaphson(
    (x) => x * x * x - 27,
    (x) => 3 * x * x,
    10.0, tol: 1e-12);
  print('  Result   : $cbrt27  (expected 3.0)\n');

  // --- reciprocal without division ---
  print('Reciprocal 1/7 (no division):');
  final rec7 = reciprocalNewton(7.0);
  print('  Result   : ${rec7.toStringAsFixed(15)}');
  print('  1/7 exact: ${(1.0/7.0).toStringAsFixed(15)}');
  print('  Error    : ${(rec7 - 1.0/7.0).abs().toStringAsExponential(3)}\n');

  print('Reciprocal 1/(-3.14):');
  final recNeg = reciprocalNewton(-3.14);
  print('  Result   : ${recNeg.toStringAsFixed(15)}');
  print('  Expected : ${(1.0/-3.14).toStringAsFixed(15)}\n');

  // --- convergence rate demonstration ---
  print('Quadratic convergence of sqrt(2) — errors per iteration:');
  double x = 1.0;
  final truth = math.sqrt(2);
  for (int i = 0; i < 8; i++) {
    final err = (x - truth).abs();
    print('  iter $i: error = ${err == 0 ? "0 (machine zero)" : err.toStringAsExponential(4)}');
    x = (x + 2.0 / x) / 2;
  }
  print('  Each step roughly squares the error — from ~0.4 to machine epsilon in 6 steps.');
}
