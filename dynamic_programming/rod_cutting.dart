// Given prices for each length 1..n, find the maximum revenue obtainable
// by cutting a rod of length n into pieces.
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
