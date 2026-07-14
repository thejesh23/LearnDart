// Returns (g, x, y) such that a*x + b*y == g == gcd(a, b).
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
