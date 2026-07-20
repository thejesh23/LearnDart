// Enumerate all divisors of n in ascending order.
//
// The naïve O(n) scan tests every candidate 1..n. The O(√n) trick
// exploits divisor symmetry: if i divides n then so does n/i, so
// we only need to iterate i up to √n and record both endpoints of
// each divisor pair. To keep the output sorted, collect the
// "small" divisors on the way up and the "large" divisors on a
// separate stack, then concatenate.
//
// Use case: prime-factorisation warm-up, number-theoretic
// exploration (perfect / abundant / deficient numbers via divisor
// sums), tighter loops in problems like Project Euler #12
// (highly-divisible triangular number).
import 'dart:math';

List<int> divisors(int n) {
  if (n <= 0) throw ArgumentError('n must be positive');
  final small = <int>[];
  final large = <int>[];
  final root = sqrt(n).toInt();
  for (int i = 1; i <= root; i++) {
    if (n % i == 0) {
      small.add(i);
      if (i != n ~/ i) large.add(n ~/ i);
    }
  }
  return [...small, ...large.reversed];
}

void main() {
  print(divisors(1));   // [1]
  print(divisors(12));  // [1, 2, 3, 4, 6, 12]
  print(divisors(28));  // [1, 2, 4, 7, 14, 28] — perfect: 1+2+4+7+14 = 28
  print(divisors(36));  // [1, 2, 3, 4, 6, 9, 12, 18, 36]  (perfect square)
  print(divisors(97));  // [1, 97]              (prime)
}
