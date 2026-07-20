import 'dart:math';

// Sieve of Atkin: a modern prime sieve invented in 2003 that improves
// the asymptotic time of the classical Sieve of Eratosthenes by using
// specific quadratic forms modulo 60 to identify primes.
//
// The idea: a number n > 3 is prime iff an odd count of (x, y) pairs
// satisfy one of three quadratic equations for the right residue class
// of n mod 12. Toggle the primality flag each time such a pair is
// found; primes end up flagged an odd number of times. Then eliminate
// squares of primes (like a mini-Eratosthenes) to remove any remaining
// composites.
//
// Complexity: O(n / log log n) — a small asymptotic edge on Eratosthenes'
// O(n log log n), and modestly faster in practice for very large n.
// See maths/sieve_of_eratosthenes.dart for the classical form and
// number_theory/linear_sieve.dart for a strict O(n) alternative.
List<int> sieveOfAtkin(int limit) {
  if (limit < 2) return const [];
  final isPrime = List<bool>.filled(limit + 1, false);
  final sqrtLimit = sqrt(limit).floor();
  for (int x = 1; x <= sqrtLimit; x++) {
    for (int y = 1; y <= sqrtLimit; y++) {
      int n = 4 * x * x + y * y;
      if (n <= limit && (n % 12 == 1 || n % 12 == 5)) isPrime[n] ^= true;
      n = 3 * x * x + y * y;
      if (n <= limit && n % 12 == 7) isPrime[n] ^= true;
      n = 3 * x * x - y * y;
      if (x > y && n <= limit && n % 12 == 11) isPrime[n] ^= true;
    }
  }
  for (int r = 5; r <= sqrtLimit; r++) {
    if (isPrime[r]) {
      for (int i = r * r; i <= limit; i += r * r) isPrime[i] = false;
    }
  }
  final primes = <int>[];
  if (limit >= 2) primes.add(2);
  if (limit >= 3) primes.add(3);
  for (int i = 5; i <= limit; i++) {
    if (isPrime[i]) primes.add(i);
  }
  return primes;
}

void main() {
  print(sieveOfAtkin(30));
  print('primes up to 100: ${sieveOfAtkin(100).length}');
}
