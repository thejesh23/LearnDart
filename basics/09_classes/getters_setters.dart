// A *getter* looks like a field but runs code when read. A *setter* runs
// code when a value is assigned. Together they let you expose computed
// values or validate incoming values without changing how callers write it.
class Rectangle {
  double width;
  double height;

  Rectangle(this.width, this.height);

  // Read-only computed property.
  double get area => width * height;

  // Validation via setter.
  set squareSize(double side) {
    if (side < 0) throw ArgumentError('side must be non-negative');
    width = side;
    height = side;
  }
}

void main() {
  final r = Rectangle(3, 4);
  print('area: ${r.area}');   // no parentheses — it's a getter

  r.squareSize = 5;           // uses the setter
  print('after squareSize=5, area: ${r.area}');
}
