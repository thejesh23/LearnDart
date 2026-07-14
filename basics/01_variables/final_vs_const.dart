// Both `final` and `const` create variables that cannot be reassigned.
// The difference is *when* the value is known.
//
//   final : the value is fixed at runtime — once assigned, it never changes.
//   const : the value is fixed at compile time — Dart must know it before
//           the program even starts running.
//
// Rule of thumb: use `const` when you can, `final` when you must, `var`
// only when the value truly needs to change.
void main() {
  final DateTime now = DateTime.now(); // runtime value, fixed once set
  const double pi = 3.14159;           // compile-time constant

  print('now = $now');
  print('pi  = $pi');

  // now = DateTime.now(); // <-- would not compile: `final` cannot be reassigned
  // pi = 3.14;            // <-- would not compile: `const` cannot be reassigned
}
