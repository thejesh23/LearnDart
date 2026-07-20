// Linear sieve (Euler's sieve): each composite is marked exactly once by
// its smallest prime factor, giving strict O(n) work.
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
