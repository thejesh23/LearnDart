// Rabin-Karp substring search: hash a sliding window of the text and only
// compare characters when the hash matches. O(n + m) average, O(nm) worst.
const int _base = 256;
const int _mod = 1_000_000_007;

List<int> rabinKarp(String text, String pattern) {
  final n = text.length;
  final m = pattern.length;
  if (m == 0 || m > n) return const [];

  int patternHash = 0;
  int windowHash = 0;
  int power = 1;
  for (int i = 0; i < m - 1; i++) power = (power * _base) % _mod;

  for (int i = 0; i < m; i++) {
    patternHash = (patternHash * _base + pattern.codeUnitAt(i)) % _mod;
    windowHash = (windowHash * _base + text.codeUnitAt(i)) % _mod;
  }

  final matches = <int>[];
  for (int i = 0; i <= n - m; i++) {
    if (windowHash == patternHash && text.substring(i, i + m) == pattern) {
      matches.add(i);
    }
    if (i < n - m) {
      windowHash = ((windowHash - text.codeUnitAt(i) * power) * _base +
              text.codeUnitAt(i + m)) %
          _mod;
      if (windowHash < 0) windowHash += _mod;
    }
  }
  return matches;
}

void main() {
  print(rabinKarp('GEEKS FOR GEEKS', 'GEEK')); // [0, 10]
  print(rabinKarp('AABAACAADAABAABA', 'AABA')); // [0, 9, 12]
}
