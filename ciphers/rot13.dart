// ROT13 is a Caesar cipher with a fixed shift of 13 — self-inverse.
String rot13(String text) {
  final buf = StringBuffer();
  for (final rune in text.runes) {
    if (rune >= 65 && rune <= 90) {
      buf.writeCharCode(65 + (rune - 65 + 13) % 26);
    } else if (rune >= 97 && rune <= 122) {
      buf.writeCharCode(97 + (rune - 97 + 13) % 26);
    } else {
      buf.writeCharCode(rune);
    }
  }
  return buf.toString();
}

void main() {
  final s = 'Hello, ROT13!';
  final encoded = rot13(s);
  print(encoded);          // Uryyb, EBG13!
  print(rot13(encoded));   // Hello, ROT13!
}
