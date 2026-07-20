// Modular binary exponentiation — compute a^b mod m in O(log b)
// multiplications instead of b multiplications.
//
// Also called "fast power", "exponentiation by squaring", "double-
// and-add". This is *the* algorithm behind RSA, Diffie–Hellman,
// primality tests (Miller–Rabin, Fermat), and Miller's random
// number generators — anywhere a^b mod m needs to be computed for
// astronomical b.
//
// The trick: expand b in binary. If b = bₖ·2ᵏ + ... + b₁·2 + b₀,
// then a^b = ∏ (a^(2^i))^bᵢ. Precompute successive squarings of
// a (each is a·a mod m) and multiply in the ones whose bit is set.
// That's log₂(b) squarings and at most log₂(b) multiplications —
// each mod m to keep numbers bounded.
//
// Related: number_theory/modular_exponentiation.dart (the same
// algorithm, framed for general modular arithmetic),
// maths/power_iterative.dart (the non-modular version).
int powMod(int a, int b, int m) {
  if (m <= 0) throw ArgumentError('modulus must be positive');
  if (b < 0) throw ArgumentError('negative exponent needs modular inverse');
  int result = 1;
  a %= m;
  while (b > 0) {
    if (b & 1 == 1) result = (result * a) % m;
    a = (a * a) % m;
    b >>= 1;
  }
  return result;
}

void main() {
  print(powMod(2, 10, 1000));   // 24    (1024 mod 1000)
  print(powMod(3, 200, 13));    // 9     (Fermat: 3^12 ≡ 1 (mod 13))
  print(powMod(5, 0, 7));       // 1
  print(powMod(7, 256, 13));    // 9
}
