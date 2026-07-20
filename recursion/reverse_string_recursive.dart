// Reverse a string with recursion instead of an explicit loop. See
// strings/reverse_string.dart for the iterative rune-based variant.
String reverseStringRecursive(String s) {
  if (s.length <= 1) return s;
  return reverseStringRecursive(s.substring(1)) + s[0];
}

void main() {
  print(reverseStringRecursive('hello'));    // olleh
  print(reverseStringRecursive('Dart'));     // traD
  print(reverseStringRecursive(''));         // ''
}
