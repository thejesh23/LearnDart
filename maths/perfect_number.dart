// A perfect number equals the sum of its proper divisors. The first four
// are 6, 28, 496, 8128.
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
