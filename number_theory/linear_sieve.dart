// Linear sieve (Euler's sieve): generate primes up to `limit` and, as
// a bonus, record every integer's smallest prime factor (SPF).
//
// The key invariant makes each composite marked exactly once: when
// processing i, we cross off i · p for each prime p ≤ SPF(i). The
// `p > spf[i]` break enforces this — without it, i · p might be
// composite for some p > spf[i] but we'd already have marked it via
// its true smallest factor.
//
// Because every composite is touched exactly once, total work is
// strict O(n), not O(n log log n) like plain Eratosthenes. The SPF
// table is invaluable for fast factorization: factor any k ≤ limit
// in O(log k) by repeatedly dividing by spf[k].
(List<int> primes, List<int> smallestPrimeFactor) linearSieve(int limit) {
  final spf = List<int>.filled(limit + 1, 0);
  final primes = <int>[];
  for (int i = 2; i <= limit; i++) {
    if (spf[i] == 0) {
      spf[i] = i;
      primes.add(i);
    }
    for (final p in primes) {
      if (p > spf[i] || i * p > limit) break;
      spf[i * p] = p;
    }
  }
  return (primes, spf);
}

void main() {
  final (primes, spf) = linearSieve(30);
  print(primes);
  print('smallest prime factor of 12 = ${spf[12]}');
  print('smallest prime factor of 25 = ${spf[25]}');
  print('smallest prime factor of 30 = ${spf[30]}');
}
