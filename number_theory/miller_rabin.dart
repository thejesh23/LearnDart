// Deterministic Miller-Rabin primality test for 64-bit integers.
//
// General idea: write n - 1 = d · 2^r with d odd. If n is prime, then
// for any a coprime with n either a^d ≡ 1 (mod n) or a^(d · 2^i) ≡ -1
// (mod n) for some 0 ≤ i < r. A witness a violating this proves n is
// composite; passing many witnesses gives strong probabilistic evidence
// (and, for bounded n, deterministic evidence when the witness set is
// chosen carefully).
//
// The fixed witness set {2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37}
// is *provably deterministic* for every n < 3.3 · 10^14 and correct
// for every 64-bit int in practice — see Sinclair's tables.
//
// Complexity: O(k · log^3 n) with modular exponentiation as the inner
// loop. Contrast with fermat_primality.dart, which uses the same core
// congruence but no square-check and is fooled by Carmichael numbers.
int _mulMod(int a, int b, int m) {
  int result = 0;
  a %= m;
  while (b > 0) {
    if (b & 1 == 1) result = (result + a) % m;
    a = (a * 2) % m;
    b >>= 1;
  }
  return result;
}

int _powMod(int base, int exp, int m) {
  int result = 1;
  int b = base % m;
  int e = exp;
  while (e > 0) {
    if (e & 1 == 1) result = _mulMod(result, b, m);
    b = _mulMod(b, b, m);
    e >>= 1;
  }
  return result;
}

bool isPrimeMR(int n) {
  if (n < 2) return false;
  for (final p in const [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37]) {
    if (n == p) return true;
    if (n % p == 0) return false;
  }
  int d = n - 1;
  int r = 0;
  while (d & 1 == 0) { d >>= 1; r++; }
  outer:
  for (final a in const [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37]) {
    int x = _powMod(a, d, n);
    if (x == 1 || x == n - 1) continue;
    for (int i = 0; i < r - 1; i++) {
      x = _mulMod(x, x, n);
      if (x == n - 1) continue outer;
    }
    return false;
  }
  return true;
}

void main() {
  for (final n in [2, 3, 4, 561, 1_000_003, 1_000_004, 999_999_999_989]) {
    print('$n -> ${isPrimeMR(n)}');
  }
}
