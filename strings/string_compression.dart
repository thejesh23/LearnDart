// Basic run-length compression. Returns the compressed string only if it's
// shorter than the original; otherwise returns the input unchanged.
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
