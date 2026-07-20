// Number of distinct subsequences of `s` that equal `t`. Classic 2-D DP
// where dp[i][j] = ways to form t[..j] from s[..i].
int distinctSubsequences(String s, String t) {
  final m = s.length, n = t.length;
  if (n > m) return 0;
  final dp = List.generate(m + 1, (_) => List<int>.filled(n + 1, 0));
  for (int i = 0; i <= m; i++) dp[i][0] = 1;
  for (int i = 1; i <= m; i++) {
    for (int j = 1; j <= n; j++) {
      dp[i][j] = dp[i - 1][j];
      if (s[i - 1] == t[j - 1]) dp[i][j] += dp[i - 1][j - 1];
    }
  }
  return dp[m][n];
}

void main() {
  print(distinctSubsequences('rabbbit', 'rabbit'));    // 3
  print(distinctSubsequences('babgbag', 'bag'));       // 5
}
