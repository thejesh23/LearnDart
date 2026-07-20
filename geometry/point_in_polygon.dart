// Ray-casting test: shoot a horizontal ray from `point` and count how
// many polygon edges it crosses. Odd -> inside, even -> outside.
bool pointInPolygon(
    (double, double) point, List<(double, double)> polygon) {
  final n = polygon.length;
  bool inside = false;
  int j = n - 1;
  for (int i = 0; i < n; i++) {
    final (xi, yi) = polygon[i];
    final (xj, yj) = polygon[j];
    if (((yi > point.$2) != (yj > point.$2)) &&
        (point.$1 < (xj - xi) * (point.$2 - yi) / (yj - yi) + xi)) {
      inside = !inside;
    }
    j = i;
  }
  return inside;
}

void main() {
  final square = <(double, double)>[(0, 0), (4, 0), (4, 4), (0, 4)];
  print(pointInPolygon((2, 2), square));  // true
  print(pointInPolygon((5, 5), square));  // false
  print(pointInPolygon((0, 2), square));  // edge case: on boundary
}
