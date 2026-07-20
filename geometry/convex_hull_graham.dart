// Convex hull via Andrew's monotone chain (a modern variant of Graham
// scan). Sort points lexicographically, then sweep left-to-right to
// build the lower hull and right-to-left for the upper hull. Whenever
// the last three points make a clockwise turn (cross product ≤ 0), pop
// the middle one — it's inside the hull, not on it.
//
// The 2-D cross product `_cross(o, a, b)` is positive for a left turn,
// zero for collinear points, and negative for a right turn. That single
// number is the geometric primitive most hull algorithms are built on.
//
// Complexity: O(n log n) time (dominated by the sort), O(n) space.
// Alternatives: Jarvis march (gift wrapping) at O(nh); QuickHull
// (average O(n log n), worst O(n^2)); Chan's algorithm at O(n log h).
double _cross((double, double) o, (double, double) a, (double, double) b) =>
    (a.$1 - o.$1) * (b.$2 - o.$2) - (a.$2 - o.$2) * (b.$1 - o.$1);

List<(double, double)> convexHull(List<(double, double)> points) {
  if (points.length < 3) return List.of(points);
  final sorted = List<(double, double)>.of(points)
    ..sort((a, b) {
      final c = a.$1.compareTo(b.$1);
      return c != 0 ? c : a.$2.compareTo(b.$2);
    });
  final lower = <(double, double)>[];
  for (final p in sorted) {
    while (lower.length >= 2 &&
        _cross(lower[lower.length - 2], lower.last, p) <= 0) {
      lower.removeLast();
    }
    lower.add(p);
  }
  final upper = <(double, double)>[];
  for (final p in sorted.reversed) {
    while (upper.length >= 2 &&
        _cross(upper[upper.length - 2], upper.last, p) <= 0) {
      upper.removeLast();
    }
    upper.add(p);
  }
  lower.removeLast();
  upper.removeLast();
  return [...lower, ...upper];
}

void main() {
  final points = <(double, double)>[
    (0, 0), (1, 1), (2, 2), (0, 2), (2, 0), (1, 0.5),
  ];
  print(convexHull(points));
}
