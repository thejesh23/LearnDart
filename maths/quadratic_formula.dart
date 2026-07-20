// The quadratic formula — solve ax² + bx + c = 0. Given the
// discriminant D = b² − 4ac, the roots are (−b ± √D) / (2a).
// Depending on the sign of D:
//   D > 0  →  two distinct real roots.
//   D = 0  →  one repeated real root: −b/(2a).
//   D < 0  →  two complex conjugate roots.
//
// Naming trivia: in Indian mathematics this identity is credited
// to Śrīdharācārya (c. 750 CE), which is why some textbooks call
// it the Śrīdharācārya formula.
//
// Numerical footgun: the classical formula suffers from
// catastrophic cancellation when b² ≫ 4ac. The stable form is:
//
//   q = −(b + sign(b)·√D) / 2
//   x1 = q / a,  x2 = c / q
//
// The stable form is used when both roots are real to preserve
// precision. This is a compact but industrial-strength solver.
import 'dart:math';

class QuadraticRoots {
  final double? realRoot1, realRoot2;
  final ({double real, double imag})? complexRootPair;
  const QuadraticRoots.real(this.realRoot1, this.realRoot2) : complexRootPair = null;
  const QuadraticRoots.complex(this.complexRootPair) : realRoot1 = null, realRoot2 = null;
}

QuadraticRoots solveQuadratic(double a, double b, double c) {
  if (a == 0) throw ArgumentError('a must be non-zero (else it is linear)');
  final d = b * b - 4 * a * c;
  if (d >= 0) {
    final sq = sqrt(d);
    final q = -0.5 * (b + (b >= 0 ? sq : -sq));
    final x1 = q / a;
    final x2 = q == 0 ? x1 : c / q;
    return QuadraticRoots.real(x1, x2);
  }
  final re = -b / (2 * a);
  final im = sqrt(-d) / (2 * a);
  return QuadraticRoots.complex((real: re, imag: im));
}

void main() {
  final r1 = solveQuadratic(1, -3, 2);          // roots 1, 2
  print('${r1.realRoot1}, ${r1.realRoot2}');
  final r2 = solveQuadratic(1, -4, 4);          // repeated root 2
  print('${r2.realRoot1}, ${r2.realRoot2}');
  final r3 = solveQuadratic(1, 2, 5);           // complex: -1 ± 2i
  print(r3.complexRootPair);
}
