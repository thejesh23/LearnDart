// Karatsuba's algorithm (1960): multiply two n-digit numbers in
// O(n^log2(3)) ≈ O(n^1.585), beating the O(n^2) schoolbook method
// for large operands.
//
// The trick: split each n-digit number into a "high" and "low" half.
// The naive product needs four half-size multiplications; Karatsuba
// gets by with *three* by cleverly reusing:
//   z0 = xLow · yLow
//   z2 = xHigh · yHigh
//   z1 = (xLow + xHigh)(yLow + yHigh) - z0 - z2   ← one mult, not two
// Result = z2 · shift² + z1 · shift + z0.
//
// This was the first sub-quadratic multiplication algorithm ever
// discovered, and disproved a conjecture of Kolmogorov's that O(n^2)
// was optimal. Toom-Cook generalizes to smaller exponents, and
// Schönhage–Strassen / Harvey–van der Hoeven push down to almost
// O(n log n). Complexity: O(n^1.585).
BigInt karatsuba(BigInt x, BigInt y) {
  if (x.bitLength <= 32 || y.bitLength <= 32) return x * y;
  final n = (x.bitLength > y.bitLength ? x.bitLength : y.bitLength) ~/ 2;
  final shift = BigInt.one << n;
  final xHigh = x >> n;
  final xLow = x - (xHigh << n);
  final yHigh = y >> n;
  final yLow = y - (yHigh << n);

  final z0 = karatsuba(xLow, yLow);
  final z2 = karatsuba(xHigh, yHigh);
  final z1 = karatsuba(xLow + xHigh, yLow + yHigh) - z0 - z2;

  return (z2 * shift * shift) + (z1 * shift) + z0;
}

void main() {
  final a = BigInt.parse('12345678901234567890');
  final b = BigInt.parse('98765432109876543210');
  print(karatsuba(a, b));
  print(a * b);
  print(karatsuba(a, b) == a * b);
}
