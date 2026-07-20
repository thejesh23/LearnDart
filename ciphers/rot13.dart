// ROT13 is a Caesar cipher with a fixed shift of 13.
//
// Because the English alphabet has 26 letters, applying ROT13 twice gets
// you back where you started — encoding and decoding are the same
// function. That self-inverse property made it a popular way in early
// Usenet to hide spoilers or offensive text: readers who wanted to see
// it could ROT13 it back; casual scrollers would just see gibberish.
//
// Provides zero cryptographic security (there's only one possible key).
// Complexity: O(n) time and O(n) space. See ciphers/caesar_cipher.dart
// for the general shift form.
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
