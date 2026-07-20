// 0/1 knapsack: given items with weights and values and a capacity W,
// pick a subset (each item taken 0 or 1 times) that maximizes value
// without exceeding W.
//
// DP state: dp[i][w] = best value achievable using the first i items
// with capacity w. Transition: for item i, take max of "skip"
// (dp[i-1][w]) or "take" (dp[i-1][w - w_i] + v_i, if it fits).
//
// NP-hard in general — the algorithm is *pseudo*-polynomial: O(n · W)
// scales with the capacity's *value*, not its bit-length. For huge W
// the table is unusable and you need branch-and-bound or
// approximations. Contrast with greedy/fractional_knapsack.dart, where
// items are divisible and a simple density-sort is optimal.
//
// Complexity: O(n · W) time and space (compressible to O(W)).
int knapsack01(List<int> weights, List<int> values, int capacity) {
  final n = weights.length;
  final dp = List.generate(n + 1, (_) => List<int>.filled(capacity + 1, 0));
  for (int i = 1; i <= n; i++) {
    for (int w = 0; w <= capacity; w++) {
      dp[i][w] = dp[i - 1][w];
      if (weights[i - 1] <= w) {
        final take = dp[i - 1][w - weights[i - 1]] + values[i - 1];
        if (take > dp[i][w]) dp[i][w] = take;
      }
    }
  }
  return dp[n][capacity];
}

void main() {
  final weights = [1, 3, 4, 5];
  final values = [1, 4, 5, 7];
  print(knapsack01(weights, values, 7)); // 9
}
