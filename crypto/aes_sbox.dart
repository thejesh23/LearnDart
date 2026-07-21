// AES S-box — the non-linear heart of AES (FIPS 197).
// AES (Advanced Encryption Standard) is a 128-bit block cipher with
// 128/192/256-bit keys.  The SubBytes step applies the S-box to every
// byte independently to provide *confusion* (Shannon's term): breaking
// the linear relationship between plaintext and ciphertext.
//
// The S-box is constructed algebraically — not a random lookup table —
// which lets NIST prove it has no hidden structure:
//
//   1. GF(2^8) arithmetic: treat each byte as a degree-7 polynomial
//      over GF(2) with coefficients in {0,1}.  Addition is XOR.
//      Multiplication is ordinary polynomial multiplication reduced
//      mod the irreducible polynomial x^8+x^4+x^3+x+1 (= 0x11B).
//
//   2. Multiplicative inverse: find b such that a·b ≡ 1 in GF(2^8).
//      By Fermat's little theorem in a field of order 2^8, b = a^254.
//      Special case: 0 maps to 0 (no inverse defined).
//
//   3. Affine transform: multiply by an 8×8 GF(2) circulant matrix
//      and XOR with 0x63.  This prevents fixed points and provides
//      algebraic complexity for linear/differential cryptanalysis.
//
// Complexity: building the S-box is O(256) field multiplications.
// The inverse S-box (for AES decryption) is built symmetrically.
//
// Run:  dart run crypto/aes_sbox.dart

// --- GF(2^8) arithmetic ------------------------------------------------

/// Multiply two bytes in GF(2^8) mod x^8+x^4+x^3+x+1 (0x11B).
/// Uses the "peasant's multiplication" / Russian-peasant algorithm:
/// double the left operand (shift left, reduce if bit 8 set) and
/// conditionally add (XOR) it when the right operand's LSB is 1.
int gfMul(int a, int b) {
  int result = 0;
  a &= 0xff;
  b &= 0xff;
  while (b > 0) {
    if (b & 1 != 0) result ^= a;
    b >>= 1;
    a <<= 1;
    if (a & 0x100 != 0) a ^= 0x11b; // reduce mod irreducible poly
    a &= 0xff;
  }
  return result;
}

/// Multiplicative inverse in GF(2^8) via a^254 (Fermat's little theorem).
/// a^(2^8-1) = 1 for a≠0, so a^(-1) = a^(2^8-2) = a^254.
int gfInverse(int a) {
  if (a == 0) return 0;
  int result = 1;
  int base = a & 0xff;
  int exp = 254;
  while (exp > 0) {
    if (exp & 1 != 0) result = gfMul(result, base);
    base = gfMul(base, base);
    exp >>= 1;
  }
  return result;
}

// --- affine transformation --------------------------------------------

/// Apply the AES affine transformation (FIPS 197 §5.1.1).
/// Computes M·b XOR 0x63 where M is the 8×8 circulant GF(2) matrix.
/// Each output bit i = b[i] ^ b[(i+4)%8] ^ b[(i+5)%8] ^
///                         b[(i+6)%8] ^ b[(i+7)%8] ^ c[i], c = 0x63.
int affineTransform(int b) {
  int result = 0;
  for (int i = 0; i < 8; i++) {
    final bit = ((b >> i) & 1) ^
                ((b >> ((i + 4) % 8)) & 1) ^
                ((b >> ((i + 5) % 8)) & 1) ^
                ((b >> ((i + 6) % 8)) & 1) ^
                ((b >> ((i + 7) % 8)) & 1) ^
                ((0x63 >> i) & 1);
    result |= (bit << i);
  }
  return result;
}

// --- build S-box -------------------------------------------------------

List<int> buildSbox() =>
    List<int>.generate(256, (a) => affineTransform(gfInverse(a)));

List<int> buildInvSbox(List<int> sbox) {
  final inv = List<int>.filled(256, 0);
  for (int i = 0; i < 256; i++) inv[sbox[i]] = i;
  return inv;
}

// --- demo --------------------------------------------------------------

void main() {
  final sbox    = buildSbox();
  final invSbox = buildInvSbox(sbox);

  print('=== AES S-box (FIPS 197 §5.1.1) ===\n');

  // Known values from the AES specification.
  print('Spot-checks against FIPS 197:');
  print('  S-box[0x00] = 0x${sbox[0x00].toRadixString(16).padLeft(2,"0")}  (expect 0x63)');
  print('  S-box[0x01] = 0x${sbox[0x01].toRadixString(16).padLeft(2,"0")}  (expect 0x7c)');
  print('  S-box[0x53] = 0x${sbox[0x53].toRadixString(16).padLeft(2,"0")}  (expect 0xed)');
  print('  S-box[0xf0] = 0x${sbox[0xf0].toRadixString(16).padLeft(2,"0")}  (expect 0x8c)\n');

  // Full S-box printed as 16×16 hex grid.
  print('Full 256-entry S-box (16×16 hex grid):');
  print('     ' + List.generate(16, (i) => i.toRadixString(16).padLeft(2)).join(' '));
  for (int row = 0; row < 16; row++) {
    final prefix = row.toRadixString(16).padLeft(2) + ':  ';
    final cells  = List.generate(
        16, (col) => sbox[row * 16 + col].toRadixString(16).padLeft(2, '0'));
    print('$prefix${cells.join(" ")}');
  }

  // Verify the S-box and its inverse are mutual inverses.
  bool roundTrip = true;
  for (int i = 0; i < 256; i++) {
    if (invSbox[sbox[i]] != i) { roundTrip = false; break; }
  }
  print('\nInverse S-box round-trip check: $roundTrip');

  // Show that 0x00 has no fixed point after affine transform.
  print('\nFixed-point analysis:');
  int fixedPoints = 0;
  for (int i = 0; i < 256; i++) {
    if (sbox[i] == i) fixedPoints++;
  }
  print('  Fixed points (S[x]=x): $fixedPoints  (AES spec guarantees none → 0)');
}
