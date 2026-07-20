// Project Euler #1 — Multiples of 3 or 5.
// https://projecteuler.net/problem=1
//
// "If we list all the natural numbers below 10 that are multiples
//  of 3 or 5, we get 3, 5, 6 and 9. The sum of these multiples is
//  23. Find the sum of all the multiples of 3 or 5 below N."
//
// Two ways to solve, both instructive:
//
// 1. Brute force in O(n): walk 1..n-1 and add each multiple.
// 2. Closed-form in O(1) using inclusion–exclusion. Let
//    S(k) = k + 2k + ... + ⌊(n-1)/k⌋·k  =  k · m·(m+1)/2  where
//    m = ⌊(n-1)/k⌋. Multiples of both 3 and 5 are multiples of 15,
//    counted once by S(3) and once by S(5); subtract S(15) so they
//    are counted exactly once. Answer = S(3) + S(5) − S(15).
//
// The closed form makes this run in constant time even for
// n = 10¹⁸, whereas the brute force takes billions of steps.
int sumMultiplesBrute(int n) {
  int total = 0;
  for (int i = 1; i < n; i++) {
    if (i % 3 == 0 || i % 5 == 0) total += i;
  }
  return total;
}

int _sumMultiplesOf(int k, int n) {
  final m = (n - 1) ~/ k;
  return k * m * (m + 1) ~/ 2;
}

int sumMultiplesFast(int n) =>
    _sumMultiplesOf(3, n) + _sumMultiplesOf(5, n) - _sumMultiplesOf(15, n);

void main() {
  print(sumMultiplesBrute(10));  // 23
  print(sumMultiplesFast(10));   // 23
  print(sumMultiplesFast(1000)); // 233168 (the Project Euler answer)
}
