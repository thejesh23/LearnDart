import 'dart:math';

// Sieve of Atkin: a modern prime sieve running in O(n / log log n) time
// with the constant hidden behind more elaborate quadratic-form tests
// than Eratosthenes. Faster in practice for very large n.
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
