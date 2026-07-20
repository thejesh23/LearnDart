// Project Euler #4 — Largest palindrome product.
// https://projecteuler.net/problem=4
//
// "The largest palindrome made from the product of two 2-digit
//  numbers is 9009 = 91 × 99. Find the largest palindrome made
//  from the product of two 3-digit numbers."
//
// The naïve double loop is 900² ≈ 810 000 candidates, well within
// budget. Two optimisations that matter for larger factors:
//   1. Iterate downward from 999 so we can early-exit inner loops
//      whenever i*j ≤ best.
//   2. Symmetry: only consider j ≤ i (a*b = b*a).
//
// Palindrome check is done arithmetically (build the reverse via
// digit-shift) — faster than string comparison and pattern-matches
// with problem 4 and maths/is_palindrome_number.dart.
bool _isPalindromeInt(int n) {
  if (n < 0) return false;
  int rev = 0, x = n;
  while (x > 0) {
    rev = rev * 10 + x % 10;
    x ~/= 10;
  }
  return rev == n;
}

int largestPalindromeProduct(int digits) {
  int lo = 1, hi = 9;
  for (int i = 1; i < digits; i++) { lo *= 10; hi = hi * 10 + 9; }
  int best = 0;
  for (int i = hi; i >= lo; i--) {
    if (i * hi <= best) break;
    for (int j = i; j >= lo; j--) {
      final p = i * j;
      if (p <= best) break;
      if (_isPalindromeInt(p)) best = p;
    }
  }
  return best;
}

void main() {
  print(largestPalindromeProduct(2)); // 9009    (91 × 99)
  print(largestPalindromeProduct(3)); // 906609  (913 × 993, the Euler answer)
}
