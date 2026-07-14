// A "higher-order function" is one that takes another function as an
// argument, returns a function, or both. Dart treats functions as
// first-class values, so you can pass them around like any other object.
int apply(int x, int Function(int) f) => f(x);

int Function(int) multiplyBy(int factor) => (int x) => x * factor;

void main() {
  print(apply(5, (n) => n + 1));   // 6
  print(apply(5, (n) => n * n));   // 25

  final triple = multiplyBy(3);
  print(triple(4));                // 12
  print(triple(10));               // 30
}
