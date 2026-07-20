// C(n, k) via Pascal-triangle recurrence, kept in a rolling row so memory
// stays O(k). Uses BigInt to avoid overflow.
BigInt binomial(int n, int k) {
  if (k < 0 || k > n) return BigInt.zero;
  if (k > n - k) k = n - k;
  var result = BigInt.one;
  for (int i = 0; i < k; i++) {
    result = result * BigInt.from(n - i) ~/ BigInt.from(i + 1);
  }
  return result;
}

void main() {
  for (final (n, k) in [(5, 2), (10, 3), (52, 5), (100, 50)]) {
    print('C($n, $k) = ${binomial(n, k)}');
  }
}
