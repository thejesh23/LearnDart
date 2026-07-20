// Longest palindromic *subsequence* of a string — chars in original
// order, not necessarily contiguous. Longest palindromic *substring*
// (contiguous) is a different problem — see strings/manacher.dart.
//
// DP state: dp[i][j] = length of the longest palindromic subsequence
// in s[i..j]. Transition: if the endpoints match, extend the inner
// answer by 2; else recurse on either dropping the left or right end.
//
// Elegant alternative: LPS(s) == LCS(s, reverse(s)). If you already
// have an LCS routine (dynamic_programming/longest_common_subsequence.dart),
// this problem is one call away with no new code.
//
// Complexity: O(n^2) time and space.
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
