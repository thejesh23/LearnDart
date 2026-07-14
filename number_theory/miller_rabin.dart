// Deterministic Miller-Rabin for 64-bit integers using a fixed witness set.
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
