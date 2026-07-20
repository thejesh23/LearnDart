// Extended Euclidean algorithm: alongside gcd(a, b) it returns integers
// x and y satisfying Bézout's identity — a·x + b·y = gcd(a, b).
//
// The recursion carries the coefficients back up: at the base case
// gcd(a, 0) = a with (x, y) = (1, 0). At each higher call we know
// (g, x1, y1) for gcd(b, a mod b), and derive the current
// (x, y) = (y1, x1 - (a÷b)·y1).
//
// Foundational for modular arithmetic. When gcd(a, m) = 1 the returned
// x (reduced mod m) is the modular inverse of a modulo m — see
// number_theory/modular_inverse.dart, and CRT reduces to a sequence of
// extended-gcd calls (number_theory/chinese_remainder.dart).
(int g, int x, int y) extendedGcd(int a, int b) {
  if (b == 0) return (a, 1, 0);
  final (g, x1, y1) = extendedGcd(b, a % b);
  return (g, y1, x1 - (a ~/ b) * y1);
}

void main() {
  final (g, x, y) = extendedGcd(30, 18);
  print('gcd = $g, x = $x, y = $y');
  print('30*$x + 18*$y = ${30 * x + 18 * y}');
}
