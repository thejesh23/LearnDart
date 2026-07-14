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
