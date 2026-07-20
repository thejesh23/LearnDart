// Minimum cuts to partition a string so every resulting piece is a
// palindrome. Example: "aab" → "aa | b" (1 cut).
//
// Two DP passes:
//   1. isPal[i][j] — precompute which substrings are palindromes.
//   2. cuts[i] — min cuts for s[0..i]. Zero if s[0..i] is itself a
//      palindrome; else min over j of cuts[j-1] + 1 for palindromic
//      s[j..i].
//
// The "precompute then use" pattern generalizes: whenever a
// per-substring test (palindrome, valid parentheses, sum divisible
// by k) drives an outer DP, compute the test lookup table first so
// each inner transition is O(1).
//
// Complexity: O(n^2) time for both phases, O(n^2) space.
int minPalindromeCuts(String s) {
  final n = s.length;
  if (n < 2) return 0;
  final isPal = List.generate(n, (_) => List<bool>.filled(n, false));
  for (int i = 0; i < n; i++) isPal[i][i] = true;
  for (int len = 2; len <= n; len++) {
    for (int i = 0; i + len - 1 < n; i++) {
      final j = i + len - 1;
      if (s[i] == s[j] && (len == 2 || isPal[i + 1][j - 1])) {
        isPal[i][j] = true;
      }
    }
  }
  final cuts = List<int>.filled(n, 0);
  for (int i = 0; i < n; i++) {
    if (isPal[0][i]) {
      cuts[i] = 0;
      continue;
    }
    cuts[i] = i;
    for (int j = 1; j <= i; j++) {
      if (isPal[j][i] && cuts[j - 1] + 1 < cuts[i]) {
        cuts[i] = cuts[j - 1] + 1;
      }
    }
  }
  return cuts[n - 1];
}

void main() {
  print(minPalindromeCuts('aab'));     // 1
  print(minPalindromeCuts('abcbm'));   // 2
  print(minPalindromeCuts('noonabbad')); // 2
}
