// When something goes wrong, Dart throws an exception. Wrap risky code in
// `try` and handle it in `catch`. Add `finally` for cleanup that must
// happen whether or not an exception was thrown.
int safeDivide(int a, int b) {
  try {
    return a ~/ b;
  } on IntegerDivisionByZeroException {
    print('cannot divide by zero, returning 0');
    return 0;
  } catch (e) {
    print('unexpected: $e');
    return -1;
  } finally {
    print('done attempt: $a / $b');
  }
}

void main() {
  print(safeDivide(10, 2));
  print(safeDivide(10, 0));
}
