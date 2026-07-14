// An `abstract` class cannot be instantiated directly. It's a template:
// it can declare methods without a body, and subclasses must supply them.
// Use it when you want a shared interface across a family of related types.
abstract class Shape {
  double area();       // no body — subclasses must implement
  double perimeter();  // no body — subclasses must implement

  void describe() {
    print('area=${area()}, perimeter=${perimeter()}');
  }
}

class Square extends Shape {
  final double side;
  Square(this.side);

  @override
  double area() => side * side;

  @override
  double perimeter() => 4 * side;
}

void main() {
  // Shape().area(); // <-- won't compile: cannot instantiate an abstract class
  Square(3).describe();
}
