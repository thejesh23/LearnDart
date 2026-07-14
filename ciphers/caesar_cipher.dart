String caesarCipher(String text, int shift) {
  final buf = StringBuffer();
  for (final rune in text.runes) {
    if (rune >= 65 && rune <= 90) {
      buf.writeCharCode(65 + (rune - 65 + shift) % 26);
    } else if (rune >= 97 && rune <= 122) {
      buf.writeCharCode(97 + (rune - 97 + shift) % 26);
    } else {
      buf.writeCharCode(rune);
    }
  }
  return buf.toString();
}

String caesarDecipher(String text, int shift) =>
    caesarCipher(text, -shift % 26 + 26);

void main() {
  final encoded = caesarCipher('Hello, World!', 3);
  print(encoded);                          // Khoor, Zruog!
  print(caesarDecipher(encoded, 3));       // Hello, World!
}
