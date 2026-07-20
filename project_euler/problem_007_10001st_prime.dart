// Project Euler #7 — 10001st prime.
// https://projecteuler.net/problem=7
//
// "By listing the first six prime numbers 2, 3, 5, 7, 11, 13 we
//  can see that the 6th prime is 13. What is the 10 001st prime
//  number?"
//
// A sieve is the obvious tool, but a sieve needs an upper bound
// and we don't know one a priori. Two options:
//
//   1. Use the prime-counting bound: p_k ≤ k·(ln k + ln ln k) for
//      k ≥ 6 (Rosser 1938). For k = 10001, that's ≈ 114 000.
//   2. Trial-divide by all primes already found, up to √candidate.
//
// Option 2 is what we implement here — no bound needed, and each
// primality test is fast because we only trial-divide by known
// primes, not every odd number.
import 'dart:math';

int nthPrime(int n) {
  if (n < 1) throw ArgumentError('n must be ≥ 1');
  final primes = <int>[2];
  int candidate = 3;
  while (primes.length < n) {
    bool prime = true;
    final limit = sqrt(candidate).toInt();
    for (final p in primes) {
      if (p > limit) break;
      if (candidate % p == 0) { prime = false; break; }
    }
    if (prime) primes.add(candidate);
    candidate += 2;
  }
  return primes.last;
}

void main() {
  print(nthPrime(6));      // 13
  print(nthPrime(10001));  // 104743 (the Project Euler answer)
}
