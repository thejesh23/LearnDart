// Atbash cipher: replace each letter with its alphabet mirror
// (A<->Z, B<->Y, C<->X, ...). Named after the first two and last two
// letters of the Hebrew alphabet (Aleph-Tav-Bet-Shin).
//
// There is no key — the substitution is fixed — so anyone who knows
// this cipher exists can trivially decode it. Included in this repo
// only because it's a nice one-page introduction to substitution
// ciphers and to the self-inverse property that XOR and ROT13 share:
// atbash(atbash(text)) == text.
//
// Complexity: O(n) time and O(n) space.
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
