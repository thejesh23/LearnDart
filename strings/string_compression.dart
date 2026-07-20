// Basic run-length compression: replace each maximal run of identical
// characters with the character followed by the run length.
//
// If the "compressed" form ends up longer than the original (e.g. no
// repeats — every character becomes 2 chars), we return the input
// unchanged. This is why real compressors add a header and use
// variable-length codes rather than always applying RLE.
//
// Contrast with strings/run_length_encoding.dart, which always
// returns the encoded form and includes a round-tripping decode.
// Complexity: O(n) time, O(n) space.
String stringCompression(String s) {
  if (s.isEmpty) return s;
  final buf = StringBuffer();
  int i = 0;
  while (i < s.length) {
    int j = i;
    while (j < s.length && s[j] == s[i]) j++;
    buf.write(s[i]);
    buf.write(j - i);
    i = j;
  }
  final compressed = buf.toString();
  return compressed.length < s.length ? compressed : s;
}

void main() {
  print(stringCompression('aabcccccaaa'));  // a2b1c5a3
  print(stringCompression('abc'));          // abc  (compression would be longer)
  print(stringCompression(''));             // ''
}
