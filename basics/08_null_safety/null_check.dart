// When you have a nullable variable, an `if (x != null)` check *narrows*
// the type inside the block: Dart now trusts `x` is non-null and lets you
// use it without any special syntax.
int lengthOrZero(String? s) {
  if (s == null) return 0;
  return s.length; // inside here, `s` is treated as non-null String
}

void main() {
  print(lengthOrZero('hello')); // 5
  print(lengthOrZero(null));    // 0

  String? maybe;
  print('length: ${lengthOrZero(maybe)}');
  maybe = 'world';
  print('length: ${lengthOrZero(maybe)}');
}
