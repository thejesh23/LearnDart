// Recursive fast exponentiation.
int powerRecursive(int base, int exp) {
  if (exp < 0) throw ArgumentError('exp must be non-negative');
  if (exp == 0) return 1;
  final half = powerRecursive(base, exp ~/ 2);
  final sq = half * half;
  return exp.isEven ? sq : sq * base;
}

void main() {
  print(powerRecursive(2, 10)); // 1024
  print(powerRecursive(3, 5));  // 243
}
