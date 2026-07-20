// Lucas-Lehmer primality test for Mersenne numbers M_p = 2^p - 1
// (where p itself is an odd prime).
//
// Iterate s_0 = 4, s_{k+1} = s_k^2 - 2 (mod M_p). M_p is prime iff
// s_{p-2} == 0. That's it — no witnesses, no probability, exactly p - 2
// squarings.
//
// This is the *fastest known* deterministic primality test for
// Mersenne numbers and is the engine behind GIMPS (the Great Internet
// Mersenne Prime Search). Every "largest known prime" record since
// 1996 has been a Mersenne prime found by exactly this algorithm.
//
// Complexity: O(p) modular squarings, each on a p-bit integer, so
// O(p^3) with schoolbook multiplication or O(p^2 log p) with FFT.
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
