// Run-length encoding (RLE): represent runs of identical characters
// as a count followed by the character, e.g. "aaabbc" -> "3a2b1c".
//
// One of the oldest compression schemes — trivial to implement, very
// fast, and highly effective on data with long repeats (early
// bitmap/fax images, printer control codes, some game-console
// graphics formats). Useless on random or high-entropy data (where
// it makes the output *longer*). Modern general-purpose compressors
// like DEFLATE use RLE as a step inside more elaborate pipelines.
//
// Unlike strings/string_compression.dart, this always emits the
// encoded form and includes a decoder for round-tripping.
// Complexity: O(n) time, O(n) space.
String runLengthEncode(String s) {
  final buf = StringBuffer();
  int i = 0;
  while (i < s.length) {
    int j = i;
    while (j < s.length && s[j] == s[i]) j++;
    buf.write(j - i);
    buf.write(s[i]);
    i = j;
  }
  return buf.toString();
}

String runLengthDecode(String s) {
  final buf = StringBuffer();
  int i = 0;
  while (i < s.length) {
    int count = 0;
    while (i < s.length && s.codeUnitAt(i) >= 48 && s.codeUnitAt(i) <= 57) {
      count = count * 10 + (s.codeUnitAt(i) - 48);
      i++;
    }
    if (i < s.length) {
      buf.write(s[i] * count);
      i++;
    }
  }
  return buf.toString();
}

void main() {
  final s = 'aaabbcdddd';
  final encoded = runLengthEncode(s);
  print(encoded);                       // 3a2b1c4d
  print(runLengthDecode(encoded));      // aaabbcdddd
}
