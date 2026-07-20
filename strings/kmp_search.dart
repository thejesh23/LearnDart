// Knuth-Morris-Pratt substring search. Builds a longest-proper-prefix-suffix
// table so the scan never revisits a character in the text. O(n + m).
List<int> _buildLps(String pattern) {
  final m = pattern.length;
  final lps = List<int>.filled(m, 0);
  int len = 0;
  int i = 1;
  while (i < m) {
    if (pattern[i] == pattern[len]) {
      lps[i++] = ++len;
    } else if (len > 0) {
      len = lps[len - 1];
    } else {
      lps[i++] = 0;
    }
  }
  return lps;
}

List<int> kmpSearch(String text, String pattern) {
  if (pattern.isEmpty) return const [];
  final lps = _buildLps(pattern);
  final matches = <int>[];
  int i = 0, j = 0;
  while (i < text.length) {
    if (text[i] == pattern[j]) {
      i++; j++;
      if (j == pattern.length) {
        matches.add(i - j);
        j = lps[j - 1];
      }
    } else if (j > 0) {
      j = lps[j - 1];
    } else {
      i++;
    }
  }
  return matches;
}

void main() {
  print(kmpSearch('ABABDABACDABABCABAB', 'ABABCABAB')); // [10]
  print(kmpSearch('aaaa', 'aa'));                        // [0, 1, 2]
  print(kmpSearch('mississippi', 'issi'));               // [1, 4]
}
