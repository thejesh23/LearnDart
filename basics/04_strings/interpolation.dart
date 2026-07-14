// String interpolation is Dart's way of embedding values inside a string
// without messy `+` concatenation.
//
//   $variable   — inserts the variable's value
//   ${expression} — evaluates an expression and inserts the result
//
// It's clearer to read and less error-prone than string concatenation.
void main() {
  String name = 'Ada';
  int age = 36;

  print('$name is $age years old.');
  print('Next year $name will be ${age + 1}.');
  print('Uppercased: ${name.toUpperCase()}');
}
