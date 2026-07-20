import 'dart:math';

// Closest pair of points via divide and conquer in O(n log n).
//
// Sort by x, split in half by x-median, recurse on each side to get the
// closest pair *within* each half. Let d = min of the two best distances.
// The trick — and the reason this beats O(n^2) — is that the closest
// cross-side pair must both lie in a vertical strip of width 2d around
// the split line. And within that strip, sorted by y, each point only
// needs to check ~7 neighbors ahead of it (a geometric packing argument).
//
// Complexity: T(n) = 2·T(n/2) + O(n) = O(n log n) time, O(n) space.
// A naïve pairwise comparison would be O(n^2). Foundational algorithm
// for computational geometry, taught alongside merge sort.
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
