// Run-length encoding and decoding — unlike string_compression.dart, this
// always returns the encoded form and can round-trip back to the original.
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
