// XOR cipher: byte-wise XOR of the plaintext with a repeating key.
//
// XOR is self-inverse: (a ^ k) ^ k == a, so encoding and decoding are
// the same operation. If the key were as long as the message and truly
// random (used only once) this would be the *one-time pad* — provably
// unbreakable. With a *short repeating* key it's trivially broken:
// XOR two ciphertext regions encrypted with the same key stretch and
// the keystream cancels out, leaving plaintext-XOR-plaintext to
// frequency-analyze.
//
// Complexity: O(n) time and O(n) space. Never use for real security —
// use `dart:crypto`/`package:cryptography` for AES-GCM, ChaCha20-Poly1305.
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
