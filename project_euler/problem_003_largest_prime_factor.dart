// Project Euler #3 — Largest prime factor.
// https://projecteuler.net/problem=3
//
// "The prime factors of 13195 are 5, 7, 13 and 29. What is the
//  largest prime factor of 600851475143?"
//
// Trial division with a twist: strip 2s first, then walk odd
// divisors from 3 upward. As soon as any divisor d divides n,
// divide it out repeatedly — this guarantees the next divisor we
// find is prime (any composite divisor would have had smaller
// prime factors already removed). Stop when d² > n; whatever's
// left of n is either 1 or the last (largest) prime factor.
//
// Runtime is O(√n) in the worst case (n = prime), which for
// n ≈ 6·10¹¹ is ≈800 000 iterations — instantaneous.
int largestPrimeFactor(int n) {
  int last = -1;
  while (n % 2 == 0) { last = 2; n ~/= 2; }
  int d = 3;
  while (d * d <= n) {
    while (n % d == 0) { last = d; n ~/= d; }
    d += 2;
  }
  if (n > 1) last = n;
  return last;
}

void main() {
  print(largestPrimeFactor(13195));         // 29
  print(largestPrimeFactor(600851475143));  // 6857  (the Project Euler answer)
}
