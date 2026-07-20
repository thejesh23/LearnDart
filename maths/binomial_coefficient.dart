// Binomial coefficient C(n, k) — the number of ways to choose k items
// from n. Computed incrementally as ((n-i)/(i+1)) accumulated, which
// keeps intermediate values bounded and never requires computing n!
// directly.
//
// The `if (k > n - k) k = n - k` line uses the symmetry
// C(n, k) = C(n, n - k) to halve the work when k is close to n.
//
// Applications: probability (Bernoulli / binomial distributions),
// Pascal's triangle, combinatorial counting, DP transition-count
// formulas. Uses BigInt because C grows fast — C(52, 26) is already
// a 15-digit number. Complexity: O(k) multiplications.
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
