// Arithmetic operators do what school math taught you, with a couple of
// Dart-specific extras for integer division and remainder.
void main() {
  int a = 17;
  int b = 5;

  print('a + b  = ${a + b}');   // addition:       22
  print('a - b  = ${a - b}');   // subtraction:    12
  print('a * b  = ${a * b}');   // multiplication: 85
  print('a / b  = ${a / b}');   // division:       3.4  (always a double)
  print('a ~/ b = ${a ~/ b}');  // truncating int division: 3
  print('a % b  = ${a % b}');   // remainder (mod): 2
  print('-a     = ${-a}');      // negation:       -17

  // Increment / decrement work the same as in C-like languages.
  int counter = 0;
  counter++;
  counter += 4;
  print('counter after ++ and += 4 : $counter'); // 5
}
