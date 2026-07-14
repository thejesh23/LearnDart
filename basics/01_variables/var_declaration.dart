// A variable is a name for a value the computer holds in memory.
//
// `var` tells Dart: "figure out the type from the value I give it."
// Once inferred, the type is fixed — you cannot later assign a string to a
// variable Dart inferred as an int.
void main() {
  var name = 'Ada';   // Dart infers String
  var age = 36;       // Dart infers int
  var pi = 3.14159;   // Dart infers double

  print('name = $name');
  print('age  = $age');
  print('pi   = $pi');
}
