// Knuth-Morris-Pratt substring search. Precomputes a Longest Proper
// Prefix-Suffix (LPS) table for the pattern; when a mismatch happens
// at pattern position j, the table says how far back the pattern can
// be shifted such that a partial match is preserved — no re-scanning
// of already-matched text characters needed.
//
// The invariant that makes KMP work: after failure at pattern[j], we
// know that text[i - j..i - 1] == pattern[0..j - 1]. The LPS table
// tells us the longest proper prefix of pattern[0..j] that's also a
// suffix — exactly the amount of overlap we can carry into the next
// alignment.
//
// Complexity: O(n + m) time and O(m) space, worst case included.
// Contrast with naive O(n · m) and average-case O(n) methods like
// Boyer-Moore (strings/boyer_moore_search.dart) and Rabin-Karp
// (strings/rabin_karp.dart).
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
