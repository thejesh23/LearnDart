import 'dart:math';

// Closest pair of points via divide and conquer in O(n log n). Splits by
// x-coordinate, recurses, then merges — checking only the narrow band
// around the split line against the current best distance.
double _dist(List<double> a, List<double> b) =>
    sqrt(pow(a[0] - b[0], 2) + pow(a[1] - b[1], 2));

double _closestSorted(List<List<double>> pts) {
  final n = pts.length;
  if (n <= 3) {
    double best = double.infinity;
    for (int i = 0; i < n; i++) {
      for (int j = i + 1; j < n; j++) {
        final d = _dist(pts[i], pts[j]);
        if (d < best) best = d;
      }
    }
    return best;
  }
  final mid = n ~/ 2;
  final midX = pts[mid][0];
  final left = pts.sublist(0, mid);
  final right = pts.sublist(mid);
  final dl = _closestSorted(left);
  final dr = _closestSorted(right);
  double best = dl < dr ? dl : dr;
  final strip = [
    for (final p in pts) if ((p[0] - midX).abs() < best) p,
  ]..sort((a, b) => a[1].compareTo(b[1]));
  for (int i = 0; i < strip.length; i++) {
    for (int j = i + 1;
        j < strip.length && (strip[j][1] - strip[i][1]) < best;
        j++) {
      final d = _dist(strip[i], strip[j]);
      if (d < best) best = d;
    }
  }
  return best;
}

double closestPair(List<List<double>> points) {
  final sorted = [for (final p in points) List<double>.of(p)]
    ..sort((a, b) => a[0].compareTo(b[0]));
  return _closestSorted(sorted);
}

void main() {
  final points = [
    [2.0, 3], [12, 30], [40, 50], [5, 1], [12, 10], [3, 4],
  ];
  print(closestPair(points)); // 1.4142135623730951
}
