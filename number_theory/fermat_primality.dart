import 'dart:math';

// Fermat primality test: if n is prime, a^(n-1) ≡ 1 (mod n) for every a
// coprime with n. Probabilistic — fools Carmichael numbers, so use
// Miller-Rabin when correctness matters.
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
