import 'dart:math';

// Lloyd's algorithm for k-means clustering on 2-D points. Deterministic
// initialization (first k points) for reproducibility.
double _dist(List<double> a, List<double> b) =>
    sqrt(pow(a[0] - b[0], 2) + pow(a[1] - b[1], 2));

(List<List<double>> centroids, List<int> labels) kMeans(
    List<List<double>> points, int k,
    {int maxIters = 100}) {
  if (points.length < k) throw ArgumentError('need at least k points');
  final centroids = [for (int i = 0; i < k; i++) List<double>.of(points[i])];
  final labels = List<int>.filled(points.length, 0);

  for (int iter = 0; iter < maxIters; iter++) {
    var changed = false;
    for (int i = 0; i < points.length; i++) {
      int best = 0;
      double bestDist = _dist(points[i], centroids[0]);
      for (int c = 1; c < k; c++) {
        final d = _dist(points[i], centroids[c]);
        if (d < bestDist) { bestDist = d; best = c; }
      }
      if (labels[i] != best) { labels[i] = best; changed = true; }
    }
    if (!changed) break;

    final sums = List.generate(k, (_) => [0.0, 0.0]);
    final counts = List<int>.filled(k, 0);
    for (int i = 0; i < points.length; i++) {
      sums[labels[i]][0] += points[i][0];
      sums[labels[i]][1] += points[i][1];
      counts[labels[i]]++;
    }
    for (int c = 0; c < k; c++) {
      if (counts[c] > 0) {
        centroids[c] = [sums[c][0] / counts[c], sums[c][1] / counts[c]];
      }
    }
  }
  return (centroids, labels);
}

void main() {
  final points = <List<double>>[
    [1, 1], [1.5, 2], [3, 4], [5, 7], [3.5, 5], [4.5, 5], [3.5, 4.5],
  ];
  final (centroids, labels) = kMeans(points, 2);
  print('centroids: $centroids');
  print('labels   : $labels');
}
