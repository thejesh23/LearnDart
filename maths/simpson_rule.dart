// Simpson's 1/3 rule — numerical integration. Approximate the
// definite integral of f on [a, b] by fitting parabolas through
// consecutive triples of sample points (rather than trapezoids
// through pairs). Named for Thomas Simpson (1710–1761), though the
// formula was known to Cavalieri and Kepler before him.
//
// Split [a, b] into n subintervals of width h = (b − a)/n (n must
// be even). Then:
//
//   ∫ f dx  ≈  (h/3) · [ f(a) + f(b)
//                     + 4·(sum of f at odd indices)
//                     + 2·(sum of f at even interior indices) ]
//
// Error is O(h⁴) — vastly better than the trapezoidal rule's O(h²)
// for smooth integrands. Use this when you can evaluate f cheaply
// and want good accuracy without heroic subdivision.
//
// For non-smooth or oscillatory integrands, adaptive quadrature
// (Gauss-Kronrod, Romberg) is more robust — Simpson is the good
// default first stop.
double simpson(double Function(double) f, double a, double b, int n) {
  if (n <= 0 || n.isOdd) throw ArgumentError('n must be positive and even');
  final h = (b - a) / n;
  double sum = f(a) + f(b);
  for (int i = 1; i < n; i++) {
    final x = a + i * h;
    sum += (i.isOdd ? 4 : 2) * f(x);
  }
  return sum * h / 3;
}

void main() {
  // ∫ x² from 0 to 1 = 1/3
  print(simpson((x) => x * x, 0, 1, 100));
  // ∫ x³+2x+7 from 0 to 10 = 10⁴/4 + 100 + 70 = 2670
  print(simpson((x) => x * x * x + 2 * x + 7, 0, 10, 100));
  // Simpson is exact for cubics regardless of n (as long as n even).
  print(simpson((x) => x * x * x, 0, 1, 2)); // 0.25
}
