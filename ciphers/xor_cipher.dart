// XOR cipher: byte-wise XOR with a repeating key. Self-inverse — encoding
// and decoding are the same operation. Cryptographically weak; useful only
// for obfuscation and demos.
List<int> xorCipher(List<int> bytes, List<int> key) {
  if (key.isEmpty) throw ArgumentError('key must be non-empty');
  return [
    for (int i = 0; i < bytes.length; i++) bytes[i] ^ key[i % key.length],
  ];
}

void main() {
  final text = 'Hello, world!';
  final key = 'k3y'.codeUnits;
  final encoded = xorCipher(text.codeUnits, key);
  print(encoded);
  print(String.fromCharCodes(xorCipher(encoded, key)));
}
