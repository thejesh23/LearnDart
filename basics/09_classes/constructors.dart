// A constructor sets up a new instance. Dart offers several forms.
class Point {
  final double x;
  final double y;

  // 1. Standard constructor with an initializer list.
  Point(this.x, this.y);

  // 2. Constant constructor — enables `const Point(0, 0)` for compile-time
  //    canonicalisation. Requires all fields to be `final`.
  const Point.origin() : x = 0, y = 0;

  @override
  String toString() => '($x, $y)';
}

void main() {
  final p = Point(3, 4);
  final origin = Point.origin();
  print('p      = $p');
  print('origin = $origin');
}
