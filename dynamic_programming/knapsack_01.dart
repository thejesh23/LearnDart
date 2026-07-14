// 0/1 knapsack: pick items to maximize value without exceeding weight W.
// Standard 2-D DP; O(n * W) time.
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
