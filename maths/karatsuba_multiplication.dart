// Karatsuba's algorithm multiplies two large integers in O(n^log2(3)),
// beating the O(n^2) grade-school method for very large operands.
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
