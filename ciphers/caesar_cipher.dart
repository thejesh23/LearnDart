// Caesar cipher: shift each letter forward by a fixed amount in the
// alphabet, wrapping A..Z and a..z independently and leaving punctuation
// alone. Named for Julius Caesar, who reportedly used shift = 3.
//
// The key is a single integer (0..25) — the shift amount. Because there
// are only 26 possible keys, the cipher can be broken by trying each
// shift and picking the output that looks like English (frequency
// analysis). It's the "hello world" of cryptography — good for teaching,
// useless for security.
//
// Complexity: O(n) time and O(n) space. Related: ciphers/rot13.dart is
// this cipher hard-coded to shift = 13, and ciphers/vigenere_cipher.dart
// uses a per-position shift derived from a keyword.
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
