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
