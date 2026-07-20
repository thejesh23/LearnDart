// Length of the longest subsequence of `s` that reads the same forwards
// and backwards. LCS of `s` with reverse(s), by way of a 2-D DP.
int longestPalindromicSubsequence(String s) {
  final n = s.length;
  if (n == 0) return 0;
  final dp = List.generate(n, (_) => List<int>.filled(n, 0));
  for (int i = 0; i < n; i++) dp[i][i] = 1;
  for (int len = 2; len <= n; len++) {
    for (int i = 0; i + len - 1 < n; i++) {
      final j = i + len - 1;
      if (s[i] == s[j]) {
        dp[i][j] = 2 + (len == 2 ? 0 : dp[i + 1][j - 1]);
      } else {
        dp[i][j] = dp[i + 1][j] > dp[i][j - 1] ? dp[i + 1][j] : dp[i][j - 1];
      }
    }
  }
  return dp[0][n - 1];
}

void main() {
  print(longestPalindromicSubsequence('bbbab'));   // 4  (bbbb)
  print(longestPalindromicSubsequence('cbbd'));    // 2  (bb)
  print(longestPalindromicSubsequence('agbdba'));  // 5  (abdba)
}
