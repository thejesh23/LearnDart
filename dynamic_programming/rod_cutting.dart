// Rod cutting: given a rod of length n and a price table for each
// possible piece length, find the maximum revenue from cutting the
// rod into pieces (which are then sold individually).
//
// DP state: dp[i] = max revenue from a length-i rod. Transition: for
// each first-cut length j, compare dp[i] with prices[j-1] + dp[i-j].
//
// A single-dimensional variant of 0/1 knapsack — same "for each length
// choose the best next piece" pattern. Also isomorphic to the
// "unbounded knapsack" (each item can be used any number of times);
// contrast with dynamic_programming/knapsack_01.dart where items are
// 0/1 and the choice is more constrained.
//
// Complexity: O(n · |prices|) time, O(n) space.
int rodCutting(List<int> prices, int length) {
  final dp = List<int>.filled(length + 1, 0);
  for (int i = 1; i <= length; i++) {
    int best = 0;
    for (int j = 1; j <= i && j <= prices.length; j++) {
      final v = prices[j - 1] + dp[i - j];
      if (v > best) best = v;
    }
    dp[i] = best;
  }
  return dp[length];
}

void main() {
  final prices = [1, 5, 8, 9, 10, 17, 17, 20];
  print(rodCutting(prices, 4));  // 10
  print(rodCutting(prices, 8));  // 22
}
