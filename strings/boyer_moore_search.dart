// Boyer-Moore substring search, with the bad-character heuristic only
// (the full algorithm adds a good-suffix rule for extra shifts).
//
// Trick: compare pattern to text *right to left*. When a mismatch
// happens at text position s+j against pattern[j], look at the
// mismatched text character; if it appears in the pattern, shift the
// pattern so its rightmost occurrence of that character lines up
// with the text position. If it doesn't appear at all, shift past
// it entirely.
//
// This gives *sublinear* average behavior on random text: typical
// searches skip more than one character per comparison. Worst case
// with only the bad-character rule is O(n·m); adding the good-suffix
// rule brings it to O(n). Used inside the Unix `grep`, `strstr()`
// implementations, and text editors.
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
