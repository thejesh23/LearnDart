// Intersection of segments p1-p2 and p3-p4 using parametric form. Returns
// the point of intersection if the segments cross, or null if they don't.
(double, double)? segmentIntersection(
    (double, double) p1, (double, double) p2,
    (double, double) p3, (double, double) p4) {
  final x1 = p1.$1, y1 = p1.$2;
  final x2 = p2.$1, y2 = p2.$2;
  final x3 = p3.$1, y3 = p3.$2;
  final x4 = p4.$1, y4 = p4.$2;
  final denom = (x1 - x2) * (y3 - y4) - (y1 - y2) * (x3 - x4);
  if (denom == 0) return null; // parallel or collinear
  final t = ((x1 - x3) * (y3 - y4) - (y1 - y3) * (x3 - x4)) / denom;
  final u = -((x1 - x2) * (y1 - y3) - (y1 - y2) * (x1 - x3)) / denom;
  if (t < 0 || t > 1 || u < 0 || u > 1) return null;
  return (x1 + t * (x2 - x1), y1 + t * (y2 - y1));
}

void main() {
  print(segmentIntersection((0, 0), (4, 4), (0, 4), (4, 0))); // (2, 2)
  print(segmentIntersection((0, 0), (1, 1), (2, 2), (3, 3))); // null
  print(segmentIntersection((0, 0), (2, 0), (1, 1), (1, 2))); // null
}
