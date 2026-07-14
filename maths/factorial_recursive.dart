BigInt factorialRecursive(int n) {
  if (n < 0) throw ArgumentError('n must be non-negative');
  if (n <= 1) return BigInt.one;
  return BigInt.from(n) * factorialRecursive(n - 1);
}

void main() {
  for (final n in [0, 1, 5, 10, 25]) {
    print('$n! = ${factorialRecursive(n)}');
  }
}
