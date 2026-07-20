import 'dart:math';

// Fermat primality test: by Fermat's little theorem, if n is prime
// then for every a coprime with n, a^(n-1) ≡ 1 (mod n). Sample
// several random `a` values; if any fails the congruence, n is
// definitely composite. If all pass, n is probably prime.
//
// The dangerous case: *Carmichael numbers* (561, 1105, 1729, ...) are
// composite yet pass Fermat's test for every witness coprime with them.
// The Fermat test misses these entirely. Miller-Rabin adds an extra
// square-root check inside the exponentiation that catches Carmichael
// numbers — so for real use always prefer number_theory/miller_rabin.dart.
//
// Complexity: O(k · log n) modular exponentiations for k witnesses.
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

bool fermatIsProbablePrime(int n, {int rounds = 10}) {
  if (n < 4) return n >= 2;
  if (n.isEven) return false;
  final rng = Random();
  for (int i = 0; i < rounds; i++) {
    final a = 2 + rng.nextInt(n - 3);
    if (_powMod(a, n - 1, n) != 1) return false;
  }
  return true;
}

void main() {
  for (final n in [7, 11, 13, 15, 25, 341, 561, 1000003]) {
    print('$n -> ${fermatIsProbablePrime(n)}');
  }
}
