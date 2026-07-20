// Integer square root via Newton's method — floor(sqrt(n)) without any
// floating-point rounding.
int integerSqrt(int n) {
  if (n < 0) throw ArgumentError('n must be non-negative');
  if (n < 2) return n;
  int x = n;
  int y = (x + 1) ~/ 2;
  while (y < x) {
    x = y;
    y = (x + n ~/ x) ~/ 2;
  }
  return x;
}

void main() {
  for (final n in [0, 1, 2, 8, 9, 15, 16, 25, 1_000_000, 999_999_999_999]) {
    print('isqrt($n) = ${integerSqrt(n)}');
  }
}
