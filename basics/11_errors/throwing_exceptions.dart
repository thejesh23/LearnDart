// You throw an exception with the `throw` keyword. You can throw any
// object, but by convention it's an `Exception` or a `Error`:
//   Exception  — recoverable runtime problem (bad input, network failure)
//   Error      — programmer bug that shouldn't be caught (assertions, type errors)
int parsePositive(String s) {
  final n = int.tryParse(s);
  if (n == null) {
    throw FormatException('not a number: "$s"');
  }
  if (n < 0) {
    throw ArgumentError.value(n, 's', 'must be non-negative');
  }
  return n;
}

void main() {
  print(parsePositive('42'));
  try {
    parsePositive('hello');
  } on FormatException catch (e) {
    print('caught format: ${e.message}');
  }
  try {
    parsePositive('-3');
  } on ArgumentError catch (e) {
    print('caught argument: ${e.message}');
  }
}
