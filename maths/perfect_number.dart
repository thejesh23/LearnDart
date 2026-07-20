// Perfect number: an integer equal to the sum of its proper divisors
// (divisors excluding itself). 6 = 1+2+3, 28 = 1+2+4+7+14, 496, 8128.
//
// All known perfect numbers are even and have the form
// 2^(p-1) · (2^p - 1) where 2^p - 1 is a Mersenne prime — see
// number_theory/lucas_lehmer.dart, the test that finds them. Euler
// proved every even perfect number has this form. Whether any odd
// perfect number exists is still an open problem, one of the oldest
// unsolved questions in mathematics.
//
// The `i * i != n` guard avoids double-counting √n when n is a
// perfect square. Complexity: O(√n) time.
bool isPerfect(int n) {
  if (n < 2) return false;
  int sum = 1;
  for (int i = 2; i * i <= n; i++) {
    if (n % i == 0) {
      sum += i;
      if (i * i != n) sum += n ~/ i;
    }
  }
  return sum == n;
}

void main() {
  for (final n in [1, 6, 28, 100, 496, 500, 8128]) {
    print('$n -> ${isPerfect(n)}');
  }
}
