// Reservoir sampling — draw a uniformly random sample of k items
// from a stream whose total length N is unknown in advance, using
// only O(k) memory regardless of how long the stream runs.
//
// Problem: you're reading a log file that might contain 10 or 10
// billion lines. You want exactly k uniformly random lines without
// buffering the whole file or making two passes.
//
// Algorithm R (Vitter, 1985):
//   1. Fill the reservoir with the first k elements.
//   2. For each subsequent element at position i (1-indexed, i > k):
//      pick a random j in [1, i].  If j ≤ k, replace reservoir[j] with
//      the new element.
//
// Correctness (proof by induction):
//   After seeing i elements, each has probability k/i of being in the
//   reservoir. Base case i=k: trivially true. Inductive step i→i+1:
//   the new element enters with probability k/(i+1). Each existing
//   reservoir element survives with probability 1 - (k/(i+1)) * (1/k)
//   = 1 - 1/(i+1) = i/(i+1). Combined with the inductive hypothesis:
//   (k/i) * (i/(i+1)) = k/(i+1). ✓
//
// Algorithm L (Li, 1994) — skip optimisation:
//   Instead of examining every element, compute how many elements to
//   *skip* before the next replacement using a geometric distribution.
//   This reduces comparisons from O(N) to O(k · log(N/k)).
//   Included here because it's the variant used in production systems
//   (PostgreSQL's TABLESAMPLE BERNOULLI, Apache Spark SAMPLE).
//
// Weighted variant: Algorithm A-Chao — each item has a weight w_i;
// items with higher weight are proportionally more likely to appear.

import 'dart:math';

// ----- Algorithm R -------------------------------------------------------

/// Simple O(N) reservoir sample.
List<T> reservoirR<T>(Iterable<T> stream, int k, {Random? rng}) {
  rng ??= Random();
  final reservoir = <T>[];
  int i = 0;
  for (final item in stream) {
    i++;
    if (reservoir.length < k) {
      reservoir.add(item);
    } else {
      final j = rng.nextInt(i); // j in [0, i)
      if (j < k) reservoir[j] = item;
    }
  }
  return reservoir;
}

// ----- Algorithm L -------------------------------------------------------

/// O(k log(N/k)) reservoir sample using skip-ahead jumps.
List<T> reservoirL<T>(Iterable<T> stream, int k, {Random? rng}) {
  rng ??= Random();
  final iter = stream.iterator;
  final reservoir = <T>[];

  // Fill initial reservoir
  while (reservoir.length < k && iter.moveNext()) {
    reservoir.add(iter.current);
  }
  if (reservoir.length < k) return reservoir; // stream shorter than k

  // W is the "skip size" distribution parameter.
  double w = exp(log(rng.nextDouble()) / k);

  // Number of elements to skip before next replacement.
  int skip = (log(rng.nextDouble()) / log(1 - w)).floor();

  while (true) {
    // Advance 'skip' elements
    int s = skip;
    while (s > 0 && iter.moveNext()) s--;
    if (s > 0) break; // stream exhausted
    if (!iter.moveNext()) break;

    // Replace a random slot
    reservoir[rng.nextInt(k)] = iter.current;

    // Update w and recompute skip
    w *= exp(log(rng.nextDouble()) / k);
    skip = (log(rng.nextDouble()) / log(1 - w)).floor();
  }
  return reservoir;
}

// ----- Weighted Algorithm A-Chao -----------------------------------------

/// Weighted reservoir sample: items with higher [weights] are more likely.
/// [items] and [weights] must have the same length.
List<T> weightedReservoir<T>(
    List<T> items, List<double> weights, int k, {Random? rng}) {
  assert(items.length == weights.length);
  rng ??= Random();
  final reservoir = <T>[];
  double totalWeight = 0;

  for (int i = 0; i < items.length; i++) {
    totalWeight += weights[i];
    if (reservoir.length < k) {
      reservoir.add(items[i]);
    } else {
      // Probability of replacing: k * w_i / totalWeight
      if (rng.nextDouble() < k * weights[i] / totalWeight) {
        reservoir[rng.nextInt(k)] = items[i];
      }
    }
  }
  return reservoir;
}

// ----- demo + statistical test -------------------------------------------

void main() {
  final rng = Random(0);
  const n = 100000, k = 5, trials = 50000;

  // Each element in 0..n-1; after 'trials' samples, every slot should
  // appear roughly trials*k/n = 2.5 times in position 0, etc.
  final counts = List<int>.filled(n, 0);
  for (int t = 0; t < trials; t++) {
    final sample = reservoirL(Iterable.generate(n), k, rng: rng);
    for (final s in sample) counts[s]++;
  }
  final expected = trials * k / n;
  final variance = counts.map((c) => (c - expected) * (c - expected)).reduce((a, b) => a + b) / n;
  print('Uniformity test (Algorithm L): k=$k, N=$n, trials=$trials');
  print('  Expected count per element: ${expected.toStringAsFixed(1)}');
  print('  Variance of counts:         ${variance.toStringAsFixed(3)}  (lower = more uniform)');
  print('  Max deviation:              ${counts.map((c) => (c - expected).abs()).reduce(max).toStringAsFixed(1)}');

  // --- Weighted sampling demo ---
  print('\nWeighted sample from [A, B, C, D, E] with weights [1, 2, 3, 4, 5]:');
  final items   = ['A', 'B', 'C', 'D', 'E'];
  final weights = [1.0, 2.0, 3.0, 4.0, 5.0];
  final wCounts = {for (final i in items) i: 0};
  for (int t = 0; t < 10000; t++) {
    for (final s in weightedReservoir(items, weights, 2, rng: rng)) {
      wCounts[s] = wCounts[s]! + 1;
    }
  }
  final total = wCounts.values.reduce((a, b) => a + b);
  for (final MapEntry(:key, :value) in wCounts.entries) {
    print('  $key: ${(value / total * 100).toStringAsFixed(1)}%  (expected ~${(weights[items.indexOf(key)] / weights.reduce((a, b) => a + b) * 100).toStringAsFixed(1)}%)');
  }
}
