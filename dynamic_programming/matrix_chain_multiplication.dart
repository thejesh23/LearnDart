// Matrix Chain Multiplication: given a sequence of matrices with
// compatible dimensions, find the parenthesization that minimizes the
// scalar multiplications needed to compute the product.
//
// Matrix multiplication is associative but not commutative: (AB)C
// and A(BC) give the same matrix but can differ *massively* in cost.
// Multiplying a 10×30, 30×5, 5×60 chain as (AB)C takes 4500 mults;
// as A(BC), 27,000.
//
// DP state: dp[i][j] = min cost to multiply matrices i..j. Transition:
// try every split point k, cost is dp[i][k] + dp[k+1][j] plus the
// merge cost dims[i]·dims[k+1]·dims[j+1]. This is the classic
// interval DP; the same shape appears in optimal BST construction,
// Burrows-Wheeler transform inversion, and RNA secondary structure.
//
// Complexity: O(n^3) time, O(n^2) space.
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
