// Fractional knapsack: items are divisible. Sort by value density (value/
// weight) and take as much as possible of each in turn.
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
