// Iterative fast exponentiation (exponentiation by squaring) for non-negative
// integer exponents.
int powerIterative(int base, int exp) {
  if (exp < 0) throw ArgumentError('exp must be non-negative');
  int result = 1;
  int b = base;
  int e = exp;
  while (e > 0) {
    if (e & 1 == 1) result *= b;
    b *= b;
    e >>= 1;
  }
  return result;
}

void main() {
  print(powerIterative(2, 10));  // 1024
  print(powerIterative(3, 5));   // 243
  print(powerIterative(5, 0));   // 1
}
