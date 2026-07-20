// Project Euler #10 — Summation of primes.
// https://projecteuler.net/problem=10
//
// "Find the sum of all the primes below two million."
//
// Trial-testing every candidate would be O(n·√n) ≈ 2.8 billion
// operations. The sieve of Eratosthenes runs in O(n log log n)
// and handles n = 2·10⁶ in a few milliseconds.
//
// Neat trick to shave 2× off memory and time: only track odd
// candidates (we know 2 is the only even prime). The half-sieve
// is left as an optional flourish — the straight sieve below is
// clear enough. See maths/sieve_of_eratosthenes.dart for a deep
// walk-through of the algorithm itself.
int sumOfPrimesBelow(int n) {
  if (n <= 2) return 0;
  final composite = List<bool>.filled(n, false);
  int sum = 0;
  for (int i = 2; i < n; i++) {
    if (composite[i]) continue;
    sum += i;
    for (int j = i * i; j < n; j += i) composite[j] = true;
  }
  return sum;
}

void main() {
  print(sumOfPrimesBelow(10));       // 17     (2+3+5+7)
  print(sumOfPrimesBelow(2000000));  // 142913828922 (the Project Euler answer)
}
