// Minimum scalar multiplications needed to compute the chain product of a
// sequence of matrices. `dims` has length n+1 so dims[i-1] × dims[i] is
// the shape of matrix i.
int matrixChainOrder(List<int> dims) {
  final n = dims.length - 1;
  final dp = List.generate(n, (_) => List<int>.filled(n, 0));
  for (int len = 2; len <= n; len++) {
    for (int i = 0; i + len - 1 < n; i++) {
      final j = i + len - 1;
      dp[i][j] = 1 << 62;
      for (int k = i; k < j; k++) {
        final cost = dp[i][k] + dp[k + 1][j] + dims[i] * dims[k + 1] * dims[j + 1];
        if (cost < dp[i][j]) dp[i][j] = cost;
      }
    }
  }
  return dp[0][n - 1];
}

void main() {
  print(matrixChainOrder([1, 2, 3, 4]));      // 18
  print(matrixChainOrder([10, 30, 5, 60]));   // 4500
  print(matrixChainOrder([40, 20, 30, 10, 30])); // 26000
}
