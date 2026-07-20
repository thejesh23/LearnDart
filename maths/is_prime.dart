// Primality test by trial division. A composite n has a divisor ≤ √n,
// so if no i in [2, √n] divides n, then n is prime.
//
// Optimizations built in:
//   - Return early for n < 2 and n == 2/3
//   - Skip all even numbers after checking 2
//   - Stop the loop at √n (i·i ≤ n, avoiding a sqrt() call)
//
// Complexity: O(√n) time, O(1) space. Fast enough for numbers up to
// ~10^12. For larger inputs use probabilistic tests like
// number_theory/miller_rabin.dart (deterministic for 64-bit ints) or
// number_theory/fermat_primality.dart. For generating *many* primes,
// prefer maths/sieve_of_eratosthenes.dart.

bool isPrime(int n) {
  if (n < 2) return false;
  if (n < 4) return true;
  if (n % 2 == 0) return false;
  for (int i = 3; i * i <= n; i += 2) {
    if (n % i == 0) return false;
  }
  return true;
}

void main() {
  for (final n in [0, 1, 2, 3, 4, 17, 97, 100, 7919]) {
    print('$n prime? ${isPrime(n)}');
  }
}
