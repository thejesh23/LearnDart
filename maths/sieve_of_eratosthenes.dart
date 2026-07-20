// Sieve of Eratosthenes: enumerate all primes up to `limit` by
// crossing out multiples of each prime as it's discovered.
//
// The `j = i * i` optimization skips composites already crossed out
// by smaller primes — multiples of i below i² all have a smaller
// prime factor and are already marked. That's the difference between
// O(n log log n) and O(n log n).
//
// One of the oldest algorithms in mathematics (~200 BC, Eratosthenes
// of Cyrene). Still the fastest way to enumerate many primes for
// small n; for larger n compare with
// number_theory/sieve_of_atkin.dart and number_theory/linear_sieve.dart.
//
// Complexity: O(n log log n) time, O(n) space.

List<int> sieveOfEratosthenes(int limit) {
  if (limit < 2) return const [];
  final isComposite = List<bool>.filled(limit + 1, false);
  final primes = <int>[];
  for (int i = 2; i <= limit; i++) {
    if (isComposite[i]) continue;
    primes.add(i);
    for (int j = i * i; j <= limit; j += i) {
      isComposite[j] = true;
    }
  }
  return primes;
}

void main() {
  print(sieveOfEratosthenes(30));
  print('primes up to 100: ${sieveOfEratosthenes(100).length}');
}
