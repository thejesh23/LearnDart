// Longest Common Substring (LCS-substring). Contrast with
// dynamic_programming/longest_common_subsequence.dart:
//   - Subsequence: characters in order, gaps allowed.
//   - Substring:   characters in order and *contiguous*.
//
// The DP: dp[i][j] = length of longest common substring ending
// exactly at s[i-1] and t[j-1]. Recurrence:
//
//   dp[i][j] = dp[i-1][j-1] + 1     if s[i-1] == t[j-1]
//            = 0                     otherwise
//
// The overall answer is max(dp[i][j]) across all cells (the
// "ending exactly here" DP again — same shape as Kadane). To
// recover the substring itself, remember the (i, best-length)
// where the max was achieved and slice.
//
// Complexity: O(m·n) time and space; can be reduced to O(min(m,n))
// space by keeping only two rolling rows. Applications: DNA-
// sequence alignment (with the more general Smith–Waterman),
// plagiarism detection, and file-diff tools.
int longestCommonSubstringLength(String s, String t) {
  final m = s.length, n = t.length;
  if (m == 0 || n == 0) return 0;
  final dp = List.generate(m + 1, (_) => List<int>.filled(n + 1, 0));
  int best = 0;
  for (int i = 1; i <= m; i++) {
    for (int j = 1; j <= n; j++) {
      if (s.codeUnitAt(i - 1) == t.codeUnitAt(j - 1)) {
        dp[i][j] = dp[i - 1][j - 1] + 1;
        if (dp[i][j] > best) best = dp[i][j];
      }
    }
  }
  return best;
}

String longestCommonSubstring(String s, String t) {
  final m = s.length, n = t.length;
  if (m == 0 || n == 0) return '';
  final dp = List.generate(m + 1, (_) => List<int>.filled(n + 1, 0));
  int best = 0, endI = 0;
  for (int i = 1; i <= m; i++) {
    for (int j = 1; j <= n; j++) {
      if (s.codeUnitAt(i - 1) == t.codeUnitAt(j - 1)) {
        dp[i][j] = dp[i - 1][j - 1] + 1;
        if (dp[i][j] > best) { best = dp[i][j]; endI = i; }
      }
    }
  }
  return s.substring(endI - best, endI);
}

void main() {
  print(longestCommonSubstringLength('abcdef', 'bcd'));   // 3
  print(longestCommonSubstring('abcdef', 'zbcdz'));       // bcd
  print(longestCommonSubstring('OldSite:GeeksforGeeks',
                               'NewSite:GeeksQuiz'));      // Site:Geeks
}
