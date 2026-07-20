// Ugly numbers: positive integers whose *only* prime factors are
// 2, 3, or 5. So 1, 2, 3, 4, 5, 6, 8, 9, 10, 12, 15, 16, ... The
// name is deliberate irony — 7, 11, 13 and their multiples are
// "ugly" from a Hamming-numbers perspective (Hamming numbers is
// the more neutral term).
//
// Two operations:
//
//   isUgly(n): keep dividing out 2, 3, 5 until you can't; you're
//     left with 1 (ugly) or some other prime (not ugly). O(log n).
//
//   nthUgly(n): the naïve "test each integer, count hits" is O(n²
//     log n)-ish. The clean O(n) DP: keep three pointers i2, i3, i5
//     into the ugly array; the next ugly number is the minimum of
//     u[i2]·2, u[i3]·3, u[i5]·5, and each pointer that produced the
//     min advances. This dedupes automatically because when two
//     candidates tie, both pointers advance. LeetCode #264.
import 'dart:math';

bool isUgly(int n) {
  if (n <= 0) return false;
  for (final p in const [2, 3, 5]) {
    while (n % p == 0) n ~/= p;
  }
  return n == 1;
}

int nthUglyNumber(int n) {
  if (n < 1) throw ArgumentError('n must be ≥ 1');
  final u = List<int>.filled(n, 1);
  int i2 = 0, i3 = 0, i5 = 0;
  for (int k = 1; k < n; k++) {
    final next = min(u[i2] * 2, min(u[i3] * 3, u[i5] * 5));
    u[k] = next;
    if (next == u[i2] * 2) i2++;
    if (next == u[i3] * 3) i3++;
    if (next == u[i5] * 5) i5++;
  }
  return u[n - 1];
}

void main() {
  print(isUgly(6));   // true
  print(isUgly(14));  // false  (contains factor 7)
  print(isUgly(1));   // true   (by convention)

  print(nthUglyNumber(1));   // 1
  print(nthUglyNumber(10));  // 12
  print(nthUglyNumber(150)); // 5832
}
