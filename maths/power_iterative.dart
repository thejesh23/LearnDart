// Fast exponentiation by squaring, iterative form.
//
// Naive `for i in 1..exp: result *= base` is O(exp) multiplications.
// This is O(log exp): process the exponent's bits — square the running
// base at every step, and multiply the accumulator only when the
// current bit is 1.
//
// This trick is what makes cryptographic operations (RSA, Diffie-
// Hellman) computationally feasible. Combined with modular reduction
// after each op, it gives number_theory/modular_exponentiation.dart.
// The recursive form lives in maths/power_recursive.dart.
//
// Complexity: O(log exp) integer multiplications.
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
