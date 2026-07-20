// Shoelace formula (Gauss's area formula): compute the area of a simple
// (non-self-intersecting) polygon from just its vertex coordinates.
//
// Sum over each edge (x_i * y_{i+1} - x_{i+1} * y_i); the absolute
// value of half the sum is the area. The name comes from how the
// cross-multiplied terms visually "lace up" if you write them in
// two columns. The signed version tells you orientation: positive for
// counter-clockwise vertex order, negative for clockwise.
//
// Requires the polygon to be simple. Self-intersecting polygons (like a
// figure-8) give a weighted sum of enclosed regions instead of a plain
// area. Complexity: O(n) time and O(1) space.
double polygonArea(List<(double, double)> vertices) {
  final n = vertices.length;
  if (n < 3) return 0;
  double sum = 0;
  for (int i = 0; i < n; i++) {
    final (x1, y1) = vertices[i];
    final (x2, y2) = vertices[(i + 1) % n];
    sum += x1 * y2 - x2 * y1;
  }
  return sum.abs() / 2;
}

void main() {
  print(polygonArea([(0, 0), (4, 0), (4, 3), (0, 3)])); // 12  (rectangle)
  print(polygonArea([(0, 0), (4, 0), (2, 3)]));         // 6   (triangle)
  print(polygonArea([(0, 0), (2, 0), (2, 2), (0, 2), (1, 1)])); // 3
}
