// `late` tells Dart: "I promise to give this variable a value before anyone
// reads it — just not right now."
//
// Two common uses:
//   1. Non-null variable that will be set in an initializer method or setup.
//   2. Expensive value you want to compute *only* the first time it is read
//      (lazy initialization).
late String greeting;

late final String expensiveComputation = _computeSlowly();

String _computeSlowly() {
  print('  (computing the expensive value...)');
  return 'computed once, cached forever';
}

void main() {
  greeting = 'Hello, late world!';
  print(greeting);

  print('reading expensiveComputation the first time:');
  print('  -> ${expensiveComputation}');

  print('reading it again — no recomputation:');
  print('  -> ${expensiveComputation}');
}
