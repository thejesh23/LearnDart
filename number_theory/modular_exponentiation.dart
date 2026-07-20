// Compute (base^exp) mod m without ever forming the intermediate huge
// value base^exp. Square-and-multiply: process the exponent bit by bit;
// square the running base at each step, and multiply the result by the
// base whenever that bit is 1.
//
// The reduction `% m` after each multiplication keeps intermediate
// values bounded. Without it, base^exp would grow astronomically —
// this trick is what makes RSA, Diffie-Hellman, ElGamal, and most
// public-key crypto tractable to compute.
//
// Complexity: O(log exp) multiplications, each an O(log m) integer op
// on multi-word arithmetic. For very large moduli use `BigInt.modPow`
// which is highly optimized. See maths/power_iterative.dart for the
// non-modular variant.
int modPow(int base, int exp, int m) {
  if (m == 1) return 0;
  int result = 1;
  int b = base % m;
  int e = exp;
  while (e > 0) {
    if (e & 1 == 1) result = (result * b) % m;
    b = (b * b) % m;
    e >>= 1;
  }
  return result;
}

void main() {
  print(modPow(2, 10, 1000));      // 24
  print(modPow(3, 200, 13));       // 9
  print(modPow(7, 256, 13));       // 9
}
