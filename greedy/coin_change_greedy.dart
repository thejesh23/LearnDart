// Greedy coin change: always pick the largest coin that fits. Optimal for
// canonical currency systems (USD, EUR, INR); for arbitrary denominations
// use the DP variant in dynamic_programming/coin_change.dart.
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
