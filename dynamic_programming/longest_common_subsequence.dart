// Longest Common Subsequence (LCS): length of the longest sequence of
// characters appearing in both strings in the same order — but not
// necessarily contiguously. So LCS('ABCBDAB', 'BDCABA') = 4 ('BCBA'
// or 'BDAB').
//
// DP state: dp[i][j] = LCS length of a[0..i] and b[0..j]. Transition:
// if the current characters match, extend the diagonal (dp[i-1][j-1]+1);
// otherwise take the best of dropping one char from either side.
//
// Foundation of diff tools (Unix `diff`, git's diff engine), DNA
// sequence alignment (with modified scoring), and code-similarity
// analyzers. Contrast with edit_distance.dart — LCS asks "what
// preserves the most?", edit distance asks "what changes the least?".
//
// Complexity: O(m · n) time and space, reducible to O(min(m, n)) space.

int longestCommonSubsequence(String a, String b) {
  final m = a.length, n = b.length;
  final dp = List.generate(m + 1, (_) => List<int>.filled(n + 1, 0));
  for (int i = 1; i <= m; i++) {
    for (int j = 1; j <= n; j++) {
      if (a[i - 1] == b[j - 1]) {
        dp[i][j] = dp[i - 1][j - 1] + 1;
      } else {
        dp[i][j] = dp[i - 1][j] > dp[i][j - 1] ? dp[i - 1][j] : dp[i][j - 1];
      }
    }
  }
  return dp[m][n];
}

void main() {
  print(longestCommonSubsequence('ABCBDAB', 'BDCABA')); // 4 (BCBA or BDAB)
  print(longestCommonSubsequence('AGGTAB', 'GXTXAYB')); // 4 (GTAB)
}
