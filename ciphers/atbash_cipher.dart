// Atbash cipher: replace each letter with its mirror in the alphabet
// (A<->Z, B<->Y, ...). Self-inverse; case-preserving.
String atbash(String text) {
  final buf = StringBuffer();
  for (final rune in text.runes) {
    if (rune >= 65 && rune <= 90) {
      buf.writeCharCode(90 - (rune - 65));
    } else if (rune >= 97 && rune <= 122) {
      buf.writeCharCode(122 - (rune - 97));
    } else {
      buf.writeCharCode(rune);
    }
  }
  return buf.toString();
}

void main() {
  final s = 'Hello, World!';
  final encoded = atbash(s);
  print(encoded);         // Svool, Dliow!
  print(atbash(encoded)); // Hello, World!
}
