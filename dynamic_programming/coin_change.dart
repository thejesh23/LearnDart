// Minimum-coins coin change: fewest coins from `coins` that sum to
// `amount`. Returns -1 if the amount cannot be formed exactly.
//
// DP state: dp[a] = fewest coins summing to a. Transition: for each
// coin c ≤ a, dp[a] = min(dp[a], dp[a - c] + 1). Start with dp[0] = 0.
//
// This is the *exact* answer that greedy/coin_change_greedy.dart can
// only approximate. Greedy is optimal for canonical currencies (USD,
// EUR, INR) but fails on arbitrary denominations — DP always works.
//
// Complexity: O(amount · |coins|) time, O(amount) space. Like 0/1
// knapsack, pseudo-polynomial — scales with the value of `amount`,
// not its bit-length.
int coinChange(List<int> coins, int amount) {
  const inf = 1 << 30;
  final dp = List<int>.filled(amount + 1, inf);
  dp[0] = 0;
  for (int a = 1; a <= amount; a++) {
    for (final c in coins) {
      if (c <= a && dp[a - c] + 1 < dp[a]) {
        dp[a] = dp[a - c] + 1;
      }
    }
  }
  return dp[amount] == inf ? -1 : dp[amount];
}

void main() {
  print(coinChange([1, 2, 5], 11)); // 3  (5+5+1)
  print(coinChange([2], 3));        // -1
  print(coinChange([1, 5, 10, 25], 63)); // 6 (25+25+10+1+1+1)
}
