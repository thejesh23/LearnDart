// Fractional knapsack: items are divisible — you can take any fraction
// of an item. Sort by value density (value ÷ weight) and take as much
// as possible of each in turn until the sack is full.
//
// The greedy strategy is optimal *only* because fractions are allowed:
// there's no situation where breaking a lower-density item in half beats
// filling with the highest-density item first. Compare with 0/1 knapsack
// (dynamic_programming/knapsack_01.dart), where items are indivisible
// and the greedy choice can be badly suboptimal — DP is required.
//
// Complexity: O(n log n) time (sort), O(n) space.
double fractionalKnapsack(List<int> weights, List<int> values, int capacity) {
  final n = weights.length;
  final order = List<int>.generate(n, (i) => i)
    ..sort((a, b) => (values[b] / weights[b]).compareTo(values[a] / weights[a]));

  double total = 0;
  int remaining = capacity;
  for (final i in order) {
    if (remaining == 0) break;
    if (weights[i] <= remaining) {
      total += values[i];
      remaining -= weights[i];
    } else {
      total += values[i] * remaining / weights[i];
      remaining = 0;
    }
  }
  return total;
}

void main() {
  final weights = [10, 20, 30];
  final values = [60, 100, 120];
  print(fractionalKnapsack(weights, values, 50)); // 240.0
}
