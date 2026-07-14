// Reverse code units. For multi-byte grapheme clusters (emoji, combining
// marks) use a grapheme-aware library instead.
String reverseString(String s) {
  return String.fromCharCodes(s.runes.toList().reversed);
}

void main() {
  print(reverseString('hello'));   // olleh
  print(reverseString('Dart 3'));  // 3 traD
}
