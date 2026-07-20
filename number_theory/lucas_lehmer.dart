// Lucas-Lehmer primality test for Mersenne numbers 2^p - 1 where p is an
// odd prime. The sequence s0 = 4, s(k+1) = s(k)^2 - 2 is computed mod Mp;
// 2^p - 1 is prime iff s(p-2) == 0.
bool isPrimeInt(int n) {
  if (n < 2) return false;
  if (n < 4) return true;
  if (n.isEven) return false;
  for (int i = 3; i * i <= n; i += 2) {
    if (n % i == 0) return false;
  }
  return true;
}

bool lucasLehmer(int p) {
  if (p == 2) return true;
  if (!isPrimeInt(p)) return false;
  final mp = (BigInt.one << p) - BigInt.one;
  var s = BigInt.from(4);
  for (int i = 0; i < p - 2; i++) {
    s = (s * s - BigInt.two) % mp;
  }
  return s == BigInt.zero;
}

void main() {
  for (final p in [3, 5, 7, 11, 13, 17, 19, 23, 31]) {
    print('M($p) = ${(BigInt.one << p) - BigInt.one}  prime? ${lucasLehmer(p)}');
  }
}
