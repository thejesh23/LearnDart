// Count distinct subsequences of `s` that equal `t`. Example:
// s = "rabbbit", t = "rabbit" → 3 (three different positions of the
// second 'b' can be dropped from s).
//
// DP state: dp[i][j] = number of ways to form t[0..j] as a
// subsequence of s[0..i]. Transition: we can always ignore s[i-1]
// (dp[i-1][j] ways). If s[i-1] == t[j-1], we can also match it
// (dp[i-1][j-1] additional ways).
//
// Base case: dp[i][0] = 1 for all i (the empty target is always
// matched by exactly one — the empty subsequence). That "1" is the
// row that seeds every other entry.
//
// Complexity: O(m · n) time and space; can compress to O(n) using
// the same "iterate backwards" trick as knapsack.
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
