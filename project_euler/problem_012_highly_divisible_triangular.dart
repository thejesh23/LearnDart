// Project Euler #12 — Highly divisible triangular number.
// https://projecteuler.net/problem=12
//
// "The nth triangular number is T_n = n(n+1)/2. What is the value
//  of the first triangular number to have over five hundred
//  divisors?"
//
// The naïve count-divisors-of-T is O(√T). Since T grows quadratically
// with n, and we need ≈13000 iterations to find the answer, that
// budget is fine — but there's a much prettier optimisation using
// the fact that gcd(n, n+1) = 1:
//
//   d(T_n) = d(n(n+1)/2) = d(n/2)·d(n+1)     if n even
//          = d(n)·d((n+1)/2)                  if n odd
//
// So we can count divisors of the two smaller coprime factors and
// multiply — roughly 4× faster than counting divisors of T directly.
//
// The plain form is presented here for clarity.
import 'dart:math';

int _countDivisors(int n) {
  int count = 0;
  final root = sqrt(n).toInt();
  for (int i = 1; i <= root; i++) {
    if (n % i == 0) count += 2;
  }
  if (root * root == n) count--;
  return count;
}

int firstTriangleWithDivisors(int minDivisors) {
  int n = 1, t = 0;
  while (true) {
    t += n;
    if (_countDivisors(t) > minDivisors) return t;
    n++;
  }
}

void main() {
  print(firstTriangleWithDivisors(5));   // 28  (divisors: 1,2,4,7,14,28)
  print(firstTriangleWithDivisors(500)); // 76576500 (the Project Euler answer)
}
