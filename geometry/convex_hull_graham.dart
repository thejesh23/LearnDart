// Graham scan: sort points by polar angle around the lowest point, then
// keep only left turns. Returns hull vertices in counter-clockwise order.
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
