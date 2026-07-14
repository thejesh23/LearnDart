// Positional parameters are passed by *position* — the first argument
// fills the first parameter, and so on. They're the simplest kind and
// the ones you already saw in `basic_function.dart`.
//
// Wrap trailing positional parameters in `[ ]` to make them optional.
// Optional positional params can have a default value.
int add(int a, int b) => a + b;

String describePoint(int x, int y, [String label = 'point']) {
  return '$label($x, $y)';
}

void main() {
  print('add(2, 3) = ${add(2, 3)}');
  print(describePoint(1, 2));            // uses default label
  print(describePoint(3, 4, 'origin'));  // provides the optional one
}
