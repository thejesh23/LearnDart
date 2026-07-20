// Reverse a string by walking its Unicode code points backward.
//
// Correctness gotcha: this reverses *runes* (code points), not
// *graphemes* (what a human perceives as a "character"). A code point
// like U+0301 (combining acute accent) attaches to the code point
// before it — reversing them separates the accent from its base
// letter. Emoji sequences (skin-tone modifiers, ZWJ family joiners)
// hit the same problem. For truly grapheme-safe reversal, use
// `package:characters`'s `Characters` iterator.
//
// Complexity: O(n) time and O(n) space. See
// recursion/reverse_string_recursive.dart for the recursive form.
String reverseString(String s) {
  return String.fromCharCodes(s.runes.toList().reversed);
}

void main() {
  print(reverseString('hello'));   // olleh
  print(reverseString('Dart 3'));  // 3 traD
}
