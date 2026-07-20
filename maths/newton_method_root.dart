// Newton's method (Newton–Raphson) — iterative root-finding for
// smooth functions. Given a guess x_k, the next guess is:
//
//   x_{k+1} = x_k − f(x_k) / f'(x_k)
//
// Geometrically: at the current point, draw the tangent line to
// the curve; take the tangent's x-intercept as the next guess.
// When it converges, it converges *quadratically* — the number of
// correct digits roughly doubles each iteration.
//
// Caveats: needs a good starting point (a bad one can diverge or
// cycle), and needs f'(x) ≠ 0. If the derivative is unknown, we
// can approximate it with the symmetric difference quotient (see
// helper below and its cousin in maths/symmetric_derivative.dart).
//
// Newton is what pow(2.0, 0.5) uses inside the FPU, what SGD
// generalises for high-dimensional loss, and the primary tool for
// solving nonlinear equations everywhere from physics simulation
// to bond-pricing.
import 'dart:math';

double _symmetricDerivative(double Function(double) f, double x, {double h = 1e-6}) {
  return (f(x + h) - f(x - h)) / (2 * h);
}

double newtonRoot(double Function(double) f,
    {double? Function(double)? fPrime,
     double initial = 1.0, int maxIter = 100, double tol = 1e-12}) {
  double x = initial;
  for (int i = 0; i < maxIter; i++) {
    final fx = f(x);
    if (fx.abs() < tol) return x;
    final dfx = fPrime?.call(x) ?? _symmetricDerivative(f, x);
    if (dfx == 0) throw StateError('zero derivative at x=$x');
    x -= fx / dfx;
  }
  return x;
}

void main() {
  // sqrt(2): root of f(x) = x² − 2.
  final r = newtonRoot((x) => x * x - 2, initial: 1.0);
  print('sqrt(2) ≈ $r');

  // Root of sin near 3.
  final piApprox = newtonRoot(sin, initial: 3.0);
  print('π ≈ $piApprox');

  // With an explicit derivative for f(x) = x³ − 27.
  final cbrt27 = newtonRoot((x) => x * x * x - 27,
      fPrime: (x) => 3 * x * x, initial: 2.0);
  print('cbrt(27) = $cbrt27');
}
