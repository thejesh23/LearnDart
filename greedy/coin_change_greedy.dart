// Greedy coin change: always pick the largest coin that still fits.
//
// Optimal *only* for "canonical" currency systems — USD, EUR, INR, GBP —
// where the denominations are chosen so greedy always wins. Toy example
// where greedy fails: coins [1, 3, 4], target 6. Greedy takes 4+1+1 =
// 3 coins; optimal is 3+3 = 2 coins. For arbitrary denominations, use
// the DP variant in dynamic_programming/coin_change.dart (O(n · amount)).
//
// Complexity: O(k log k + k) where k is the number of denominations.
// Returns (-1, breakdown) if greedy can't reach the amount exactly.
(int totalCoins, Map<int, int> breakdown) coinChangeGreedy(
    List<int> denominations, int amount) {
  final sorted = List<int>.of(denominations)..sort((a, b) => b.compareTo(a));
  final breakdown = <int, int>{};
  int total = 0;
  int remaining = amount;
  for (final c in sorted) {
    if (c <= 0 || remaining < c) continue;
    final count = remaining ~/ c;
    breakdown[c] = count;
    total += count;
    remaining -= c * count;
  }
  return (remaining == 0 ? total : -1, breakdown);
}

void main() {
  print(coinChangeGreedy([1, 5, 10, 25], 63));
  print(coinChangeGreedy([1, 2, 5, 10, 20, 50, 100, 500, 2000], 1750));
}
