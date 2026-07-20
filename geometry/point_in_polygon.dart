// Point-in-polygon test via ray casting: shoot a horizontal ray to the
// right from the query point and count how many polygon edges it crosses.
// Odd count -> inside, even -> outside (Jordan curve theorem).
//
// Works on any simple polygon — convex, concave, or with holes if you
// treat each hole as a separate ring and sum the parities. Points
// exactly on an edge are a numerical edge case; you may need a small
// tolerance depending on your application (this file doesn't guarantee
// a stable answer on the boundary).
//
// Complexity: O(n) time, O(1) space. If you're doing many queries
// against the same polygon, precompute a horizontal-slab decomposition
// (Kirkpatrick's) for O(log n) per query at O(n log n) preprocessing.
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
