// Euler's totient function φ(n): the count of integers in [1, n] that
// share no common factor with n other than 1 (i.e. gcd(k, n) = 1).
//
// The multiplicative formula:
//     φ(n) = n · Π (1 - 1/p)
// where the product runs over distinct prime factors p of n. This
// implementation factors n on the fly (up to √n trial division) and
// multiplies the correction into `result` as each new prime is found.
//
// φ is central to Fermat–Euler theorem: a^φ(n) ≡ 1 (mod n) for any a
// coprime with n. That's the mathematical foundation of RSA — key
// generation picks φ(p·q) = (p-1)(q-1). Complexity: O(√n).
int eulerTotient(int n) {
  int result = n;
  int x = n;
  for (int p = 2; p * p <= x; p++) {
    if (x % p == 0) {
      while (x % p == 0) x ~/= p;
      result -= result ~/ p;
    }
  }
  if (x > 1) result -= result ~/ x;
  return result;
}

void main() {
  for (final n in [1, 2, 3, 6, 9, 10, 36, 100]) {
    print('phi($n) = ${eulerTotient(n)}');
  }
}
