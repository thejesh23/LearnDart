// Intersection of two line segments using the parametric form. Each
// segment is written as P + t·(Q - P) for t in [0, 1]; the intersection
// exists iff we can find t and u both in [0, 1] that make the two
// parametric points equal.
//
// The `denom` value is the 2-D cross product of the two direction
// vectors. When it's zero the segments are parallel (or collinear); no
// unique intersection point exists — collinear overlap would need a
// separate check.
//
// Complexity: O(1) time and space. Building block for polygon clipping,
// line-of-sight tests, and collision detection.
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
