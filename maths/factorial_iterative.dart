BigInt factorial(int n) {
  if (n < 0) throw ArgumentError('n must be non-negative');
  var result = BigInt.one;
  for (int i = 2; i <= n; i++) {
    result *= BigInt.from(i);
  }
  return result;
}

void main() {
  for (final n in [0, 1, 5, 10, 25]) {
    print('$n! = ${factorial(n)}');
  }
}
