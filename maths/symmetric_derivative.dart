// Symmetric (central) difference — numerical derivative of a
// function. The forward difference is (f(x+h) − f(x))/h, error
// O(h). The central form
//
//   f'(x)  ≈  (f(x+h) − f(x−h)) / (2h)
//
// cancels the first-order error term, giving O(h²) accuracy —
// twice as good for essentially no extra work.
//
// Choosing h is the practical art: too big → truncation error
// dominates; too small → floating-point cancellation dominates.
// For double precision, h ≈ ε^(1/3) ≈ 10⁻⁵ is often close to
// optimal. Higher-order stencils exist (five-point, seven-point)
// for smoother functions.
//
// Central to any code that needs a numerical gradient when the
// analytic derivative is unavailable — physics simulations,
// optimisers with black-box objectives, and Newton's method's
// fallback path (see maths/newton_method_root.dart).
import 'dart:math';

double symmetricDerivative(double Function(double) f, double x, {double h = 1e-5}) {
  return (f(x + h) - f(x - h)) / (2 * h);
}

void main() {
  // d/dx sin(x) = cos(x)
  print('d(sin)/dx at π/3 ≈ ${symmetricDerivative(sin, pi / 3)}');
  print('cos(π/3)         = ${cos(pi / 3)}');

  // d/dx e^x = e^x
  print('d(exp)/dx at 1 ≈ ${symmetricDerivative(exp, 1.0)}');
  print('e             = ${exp(1)}');

  // d/dx x² at x=3 = 6
  print('d(x²)/dx at 3 ≈ ${symmetricDerivative((x) => x * x, 3.0)}');
}
