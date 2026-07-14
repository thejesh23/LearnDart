// Shoelace formula: signed area of a simple polygon given its vertices.
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
