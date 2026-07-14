// A function is a named block of code you can call by its name. Declaring
// one has three parts:
//   1. The return type (or `void` if it returns nothing).
//   2. The name.
//   3. The parameter list.
int square(int n) {
  return n * n;
}

void greet(String name) {
  print('Hello, $name!');
}

void main() {
  print('square(4) = ${square(4)}');
  greet('Ada');
}
