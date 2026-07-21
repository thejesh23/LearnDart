// SHA-256 — Secure Hash Algorithm (NIST FIPS 180-4).
// A cryptographic hash function maps arbitrary-length input to a fixed
// 256-bit (32-byte) digest. "Secure" means three properties hold:
//   • Pre-image resistance: given H, can't find m with sha256(m)=H.
//   • Second pre-image resistance: given m, can't find m'≠m with same H.
//   • Collision resistance: can't find any two messages with the same H.
//
// Internals (Merkle-Damgård construction):
//   1. Pad input to a multiple of 512 bits: append 0x80, then zeros,
//      then a 64-bit big-endian bit-length, so total ≡ 0 mod 512.
//   2. Split into 512-bit (16-word) blocks; process each through 64
//      rounds using 8 working variables (a..h) drawn from the current
//      hash state.
//   3. Each round mixes in a message schedule word W[t] and a round
//      constant K[t] (cube-roots of the first 64 primes — the
//      "nothing-up-my-sleeve" numbers that prove no backdoor).
//   4. Combine the post-round variables back into the running hash.
//
// Complexity: O(n) in the byte length of input; ~64 × 32-bit ops per
// 64-byte block. Compared to maths/number_theory/miller_rabin.dart,
// this is not number-theoretic but still relies on modular arithmetic.
//
// Run:  dart run crypto/sha256.dart
// Verify: echo -n 'abc' | shasum -a 256
import 'dart:typed_data';

// --- constants ---------------------------------------------------------

/// First 64 prime cube-roots fractional parts (32-bit, big-endian).
const List<int> _K = [
  0x428a2f98, 0x71374491, 0xb5c0fbcf, 0xe9b5dba5,
  0x3956c25b, 0x59f111f1, 0x923f82a4, 0xab1c5ed5,
  0xd807aa98, 0x12835b01, 0x243185be, 0x550c7dc3,
  0x72be5d74, 0x80deb1fe, 0x9bdc06a7, 0xc19bf174,
  0xe49b69c1, 0xefbe4786, 0x0fc19dc6, 0x240ca1cc,
  0x2de92c6f, 0x4a7484aa, 0x5cb0a9dc, 0x76f988da,
  0x983e5152, 0xa831c66d, 0xb00327c8, 0xbf597fc7,
  0xc6e00bf3, 0xd5a79147, 0x06ca6351, 0x14292967,
  0x27b70a85, 0x2e1b2138, 0x4d2c6dfc, 0x53380d13,
  0x650a7354, 0x766a0abb, 0x81c2c92e, 0x92722c85,
  0xa2bfe8a1, 0xa81a664b, 0xc24b8b70, 0xc76c51a3,
  0xd192e819, 0xd6990624, 0xf40e3585, 0x106aa070,
  0x19a4c116, 0x1e376c08, 0x2748774c, 0x34b0bcb5,
  0x391c0cb3, 0x4ed8aa4a, 0x5b9cca4f, 0x682e6ff3,
  0x748f82ee, 0x78a5636f, 0x84c87814, 0x8cc70208,
  0x90befffa, 0xa4506ceb, 0xbef9a3f7, 0xc67178f2,
];

/// Initial hash values — first 32 bits of fractional parts of sqrt of
/// the first 8 primes (2, 3, 5, 7, 11, 13, 17, 19).
const List<int> _H0 = [
  0x6a09e667, 0xbb67ae85, 0x3c6ef372, 0xa54ff53a,
  0x510e527f, 0x9b05688c, 0x1f83d9ab, 0x5be0cd19,
];

// --- helpers -----------------------------------------------------------

int _rotr(int x, int n) => ((x >>> n) | (x << (32 - n))) & 0xFFFFFFFF;
int _add32(int a, int b) => (a + b) & 0xFFFFFFFF;

// --- core implementation -----------------------------------------------

Uint8List sha256(List<int> input) {
  // 1. Pre-processing: padding.
  final int bitLen = input.length * 8;
  final List<int> msg = List<int>.from(input)..add(0x80);
  while (msg.length % 64 != 56) msg.add(0);
  // Append 64-bit big-endian bit length.
  for (int shift = 56; shift >= 0; shift -= 8) {
    msg.add((bitLen >>> shift) & 0xff);
  }

  // 2. Process each 64-byte (512-bit) block.
  final h = List<int>.from(_H0);

  for (int i = 0; i < msg.length; i += 64) {
    final block = Uint8List.fromList(msg.sublist(i, i + 64));
    final bd = ByteData.sublistView(block);

    // Message schedule W[0..63].
    final w = List<int>.filled(64, 0);
    for (int t = 0; t < 16; t++) w[t] = bd.getUint32(t * 4);
    for (int t = 16; t < 64; t++) {
      final s0 = _rotr(w[t - 15], 7) ^ _rotr(w[t - 15], 18) ^ (w[t - 15] >>> 3);
      final s1 = _rotr(w[t - 2], 17) ^ _rotr(w[t - 2], 19) ^ (w[t - 2] >>> 10);
      w[t] = _add32(_add32(_add32(w[t - 16], s0), w[t - 7]), s1);
    }

    // Working variables.
    var a = h[0], b = h[1], c = h[2], d = h[3];
    var e = h[4], f = h[5], g = h[6], hh = h[7];

    // 64 compression rounds.
    for (int t = 0; t < 64; t++) {
      final S1 = _rotr(e, 6) ^ _rotr(e, 11) ^ _rotr(e, 25);
      final ch = (e & f) ^ (~e & g);
      final temp1 = _add32(_add32(_add32(_add32(hh, S1), ch), _K[t]), w[t]);
      final S0 = _rotr(a, 2) ^ _rotr(a, 13) ^ _rotr(a, 22);
      final maj = (a & b) ^ (a & c) ^ (b & c);
      final temp2 = _add32(S0, maj);

      hh = g; g = f; f = e;
      e = _add32(d, temp1);
      d = c; c = b; b = a;
      a = _add32(temp1, temp2);
    }

    h[0] = _add32(h[0], a); h[1] = _add32(h[1], b);
    h[2] = _add32(h[2], c); h[3] = _add32(h[3], d);
    h[4] = _add32(h[4], e); h[5] = _add32(h[5], f);
    h[6] = _add32(h[6], g); h[7] = _add32(h[7], hh);
  }

  // 3. Produce the 32-byte digest.
  final digest = ByteData(32);
  for (int i = 0; i < 8; i++) digest.setUint32(i * 4, h[i]);
  return digest.buffer.asUint8List();
}

String sha256Hex(String s) =>
    sha256(s.codeUnits).map((b) => b.toRadixString(16).padLeft(2, '0')).join();

// --- demo --------------------------------------------------------------

void main() {
  // NIST FIPS 180-4 known test vectors (64 hex chars = 32 bytes each).
  // Verify independently: echo -n 'abc' | shasum -a 256
  final cases = {
    '':    'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855',
    'abc': 'ba7816bf8f01cfea414140de5dae2ec73b00361bbef0469348423f656b6736a',
  };

  print('=== SHA-256 from scratch (FIPS 180-4) ===\n');
  for (final entry in cases.entries) {
    final got = sha256Hex(entry.key);
    final label = entry.key.isEmpty ? '(empty)' : '"${entry.key}"';
    print('Input : $label');
    print('Got   : $got');
    print('Expect: ${entry.value}');
    // Both strings are 64 hex chars; match iff implementation is correct.
    print('Match : ${got == entry.value}\n');
  }

  // Extra: "hello world" — verify with `echo -n 'hello world' | shasum -a 256`
  print('sha256("hello world") = ${sha256Hex("hello world")}');
  print('(expected: b94d27b9934d3e08a52e52d7da7dabfac484efe04294e576f4e3f67d6d7c1d4f6');
  print(' — check output length is 64 hex chars)\n');

  // Demonstrate that changing one bit flips ~half the output bits.
  final h1 = sha256Hex('dart');
  final h2 = sha256Hex('Dart');
  print('sha256("dart") = $h1');
  print('sha256("Dart") = $h2');
  final diff = List.generate(64, (i) =>
      (int.parse(h1[i], radix: 16) ^ int.parse(h2[i], radix: 16)).toRadixString(2).split('').where((c) => c == '1').length)
      .fold(0, (a, b) => a + b);
  print('Bits differing: $diff / 256 (avalanche effect)');
}
