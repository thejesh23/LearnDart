// Armstrong (a.k.a. narcissistic) number: equal to the sum of each of
// its digits raised to the power of the digit count.
//   153 = 1³ + 5³ + 3³
//   9474 = 9⁴ + 4⁴ + 7⁴ + 4⁴
//
// There are only finitely many Armstrong numbers in base 10 — exactly
// 88 of them. The largest has 39 digits. That finiteness comes from
// a simple upper-bound argument: an n-digit number is at most n · 9^n,
// which grows slower than 10^(n-1) for large n.
//
// Zero-value trivia rather than any real application — the sort of
// puzzle every "cool number properties" list eventually mentions.
// Complexity: O(d²) where d is the number of digits (dominated by
// the naive integer power).
bool isArmstrong(int n) {
  if (n < 0) return false;
  final digits = n.toString().split('').map(int.parse).toList();
  final power = digits.length;
  int sum = 0;
  for (final d in digits) {
    int p = 1;
    for (int i = 0; i < power; i++) p *= d;
    sum += p;
  }
  return sum == n;
}

void main() {
  for (final n in [0, 1, 9, 10, 153, 154, 370, 371, 407, 9474]) {
    print('$n -> ${isArmstrong(n)}');
  }
}
