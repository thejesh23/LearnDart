// Manacher's algorithm: longest palindromic substring in O(n). Adds
// sentinels between characters so odd- and even-length palindromes fall
// out of the same code path.
String longestPalindrome(String s) {
  if (s.isEmpty) return '';
  final t = '^#${s.split('').join('#')}#\$';
  final n = t.length;
  final p = List<int>.filled(n, 0);
  int c = 0, r = 0;
  for (int i = 1; i < n - 1; i++) {
    final mirror = 2 * c - i;
    if (i < r) p[i] = (r - i) < p[mirror] ? (r - i) : p[mirror];
    while (t[i + 1 + p[i]] == t[i - 1 - p[i]]) p[i]++;
    if (i + p[i] > r) { c = i; r = i + p[i]; }
  }
  int maxLen = 0, centerIndex = 0;
  for (int i = 1; i < n - 1; i++) {
    if (p[i] > maxLen) { maxLen = p[i]; centerIndex = i; }
  }
  final start = (centerIndex - maxLen) ~/ 2;
  return s.substring(start, start + maxLen);
}

void main() {
  print(longestPalindrome('babad'));                  // 'bab' or 'aba'
  print(longestPalindrome('cbbd'));                   // 'bb'
  print(longestPalindrome('forgeeksskeegfor'));       // 'geeksskeeg'
}
