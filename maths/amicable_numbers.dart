// Amicable numbers: a pair (a, b) is amicable iff the sum of the
// proper divisors of a equals b *and* vice versa. Proper divisors
// exclude the number itself. Smallest pair: (220, 284) — known to
// the Pythagoreans and later to al-Farisi, Fermat, Descartes.
//
// Compute σ(n) = sum of proper divisors in O(√n) by iterating
// divisors i from 1 to √n; when i divides n, add both i and n/i,
// then subtract n at the end. The pair (a, b) is amicable iff
// σ(a) = b and σ(b) = a. (When a = b, we have a *perfect number*
// instead; see maths/perfect_number.dart.)
//
// Beyond curio-mathematics, amicable numbers show up in
// competitive-programming warm-ups and as fodder for divisor-sum
// optimisations (Euler's totient, Möbius function relatives).
import 'dart:math';

int _sumProperDivisors(int n) {
  if (n < 2) return 0;
  int sum = 1;
  final root = sqrt(n).toInt();
  for (int i = 2; i <= root; i++) {
    if (n % i == 0) {
      sum += i;
      final other = n ~/ i;
      if (other != i) sum += other;
    }
  }
  return sum;
}

bool areAmicable(int a, int b) {
  if (a < 2 || b < 2 || a == b) return false;
  return _sumProperDivisors(a) == b && _sumProperDivisors(b) == a;
}

void main() {
  print(areAmicable(220, 284));   // true
  print(areAmicable(1184, 1210)); // true
  print(areAmicable(2620, 2924)); // true
  print(areAmicable(6, 6));       // false (perfect number, not an amicable pair)
  print(areAmicable(12, 14));     // false
}
