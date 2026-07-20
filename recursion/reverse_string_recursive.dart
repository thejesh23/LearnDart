// Reverse a string using recursion instead of an explicit loop.
//
// Every call strips one character off the front and glues it onto the
// end of whatever the recursive call returns. Elegant, but expensive:
// each `+` and `substring` allocates a new string, so the total work
// is O(n^2) time and O(n) recursion depth. For anything performance-
// sensitive prefer strings/reverse_string.dart, which builds the reversed
// result via runes in O(n).
//
// Included as a teaching contrast: the iterative version shows *how*,
// this version shows *why* — the recursive shape makes the "reverse of
// a string equals reverse-of-tail plus head" invariant explicit.
String reverseStringRecursive(String s) {
  if (s.length <= 1) return s;
  return reverseStringRecursive(s.substring(1)) + s[0];
}

void main() {
  print(reverseStringRecursive('hello'));    // olleh
  print(reverseStringRecursive('Dart'));     // traD
  print(reverseStringRecursive(''));         // ''
}
