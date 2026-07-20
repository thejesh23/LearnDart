// Vigenère cipher: a Caesar cipher with a *different* shift for each
// letter, cycling through a keyword. Encrypting position i uses shift
// key[i mod key.length] - 'a'. This defeats simple frequency analysis
// on the ciphertext, since a plaintext 'e' can become any of |key|
// different ciphertext letters.
//
// It resisted attack for three centuries until Kasiski (1863) noticed
// that repeated bigrams in the ciphertext often occur at distances that
// are multiples of the key length — giving you the key length, after
// which each column reduces to a Caesar cipher solvable by frequency.
//
// Complexity: O(n) time and O(n) space. Modern replacement: stream
// ciphers built on cryptographically secure keystream generators
// (ChaCha20, AES-CTR).
String _shiftChar(int rune, int shift) {
  if (rune >= 65 && rune <= 90) {
    return String.fromCharCode(65 + (rune - 65 + shift) % 26);
  }
  if (rune >= 97 && rune <= 122) {
    return String.fromCharCode(97 + (rune - 97 + shift) % 26);
  }
  return String.fromCharCode(rune);
}

String vigenereCipher(String text, String key, {bool decode = false}) {
  final normalizedKey = key.toLowerCase().replaceAll(RegExp(r'[^a-z]'), '');
  if (normalizedKey.isEmpty) throw ArgumentError('key must contain letters');
  final buf = StringBuffer();
  int keyIdx = 0;
  for (final rune in text.runes) {
    if ((rune >= 65 && rune <= 90) || (rune >= 97 && rune <= 122)) {
      final shift = normalizedKey.codeUnitAt(keyIdx % normalizedKey.length) - 97;
      buf.write(_shiftChar(rune, decode ? -shift : shift));
      keyIdx++;
    } else {
      buf.writeCharCode(rune);
    }
  }
  return buf.toString();
}

void main() {
  final encoded = vigenereCipher('Attack at dawn', 'lemon');
  print(encoded);
  print(vigenereCipher(encoded, 'lemon', decode: true));
}
