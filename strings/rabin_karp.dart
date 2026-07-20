// Rabin-Karp substring search: instead of comparing characters directly
// at every text position, compute a rolling hash of a sliding text
// window and compare it against the pattern's hash. Only fall back to
// character-by-character comparison on a hash match.
//
// The rolling hash lets each window transition run in O(1): subtract
// the outgoing character's contribution, shift, add the incoming
// character. Uses polynomial rolling hash h(s) = s[0]·b^{m-1} + ...
// + s[m-1], all mod a prime.
//
// Average-case O(n + m); worst case O(n·m) when many hash collisions
// force the tie-breaking string comparison. Real killer feature: the
// same setup finds *k* patterns simultaneously in O(n + k·m) via a
// hash-table lookup on each window's hash — used in plagiarism
// detection and virus signature scanning.
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
