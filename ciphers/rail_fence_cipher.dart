// Rail fence cipher: write the plaintext in a zig-zag pattern across
// `rails` rows, then read row by row. Trivial transposition cipher —
// educational only.
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
