// Boyer-Moore substring search using the bad-character heuristic. Scans
// the pattern right-to-left; a mismatched text character can shift the
// pattern by more than one position.
List<int> boyerMooreSearch(String text, String pattern) {
  final n = text.length;
  final m = pattern.length;
  if (m == 0 || m > n) return const [];

  final badChar = <int, int>{};
  for (int i = 0; i < m; i++) badChar[pattern.codeUnitAt(i)] = i;

  final matches = <int>[];
  int s = 0;
  while (s <= n - m) {
    int j = m - 1;
    while (j >= 0 && pattern[j] == text[s + j]) j--;
    if (j < 0) {
      matches.add(s);
      s += (s + m < n) ? m - (badChar[text.codeUnitAt(s + m)] ?? -1) : 1;
    } else {
      final bc = badChar[text.codeUnitAt(s + j)] ?? -1;
      final shift = j - bc;
      s += shift > 1 ? shift : 1;
    }
  }
  return matches;
}

void main() {
  print(boyerMooreSearch('ABAAABCD', 'ABC'));                  // [4]
  print(boyerMooreSearch('AABAACAADAABAABA', 'AABA'));         // [0, 9, 12]
}
