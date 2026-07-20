// Rail fence cipher: a *transposition* cipher (as opposed to a
// substitution cipher). The letters themselves aren't changed — only
// their positions. Write the plaintext across `rails` rows in a
// zig-zag pattern, then concatenate the rows to get the ciphertext.
//
// Example with rails = 3 on "HELLOWORLD":
//     H . . . O . . . L .
//     . E . L . W . R . D
//     . . L . . . O . . .
// Reading row by row: HOL ELWRD LO.
//
// Encoding is straightforward; decoding needs a two-pass approach to
// reconstruct the zig-zag pattern and then re-slot each ciphertext
// letter back into its original column.
//
// The key is just the number of rails, so brute-forcing takes at most
// a few dozen tries — negligible security. It's a good introduction to
// transposition ciphers and to the general encode/decode symmetry of
// permutation-based encryption.
//
// Complexity: O(n) time and O(n) space for both directions.
String railFenceEncode(String text, int rails) {
  if (rails <= 1) return text;
  final rows = List.generate(rails, (_) => StringBuffer());
  int row = 0, dir = 1;
  for (final ch in text.split('')) {
    rows[row].write(ch);
    if (row == 0) dir = 1;
    else if (row == rails - 1) dir = -1;
    row += dir;
  }
  return rows.map((r) => r.toString()).join();
}

String railFenceDecode(String cipher, int rails) {
  if (rails <= 1) return cipher;
  final pattern = List<int>.filled(cipher.length, 0);
  int row = 0, dir = 1;
  for (int i = 0; i < cipher.length; i++) {
    pattern[i] = row;
    if (row == 0) dir = 1;
    else if (row == rails - 1) dir = -1;
    row += dir;
  }
  final counts = List<int>.filled(rails, 0);
  for (final r in pattern) counts[r]++;
  final rowStart = List<int>.filled(rails, 0);
  for (int r = 1; r < rails; r++) rowStart[r] = rowStart[r - 1] + counts[r - 1];
  final indices = List<int>.of(rowStart);
  final out = List<String>.filled(cipher.length, '');
  for (int i = 0; i < cipher.length; i++) {
    final r = pattern[i];
    out[i] = cipher[indices[r]++];
  }
  return out.join();
}

void main() {
  final s = 'WEAREDISCOVEREDFLEEATONCE';
  final encoded = railFenceEncode(s, 3);
  print(encoded);
  print(railFenceDecode(encoded, 3));
}
