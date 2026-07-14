// Levenshtein distance: minimum single-character edits (insert, delete,
// substitute) to transform `a` into `b`.
int editDistance(String a, String b) {
  final m = a.length, n = b.length;
  final dp = List.generate(m + 1, (_) => List<int>.filled(n + 1, 0));
  for (int i = 0; i <= m; i++) dp[i][0] = i;
  for (int j = 0; j <= n; j++) dp[0][j] = j;
  for (int i = 1; i <= m; i++) {
    for (int j = 1; j <= n; j++) {
      if (a[i - 1] == b[j - 1]) {
        dp[i][j] = dp[i - 1][j - 1];
      } else {
        final del = dp[i - 1][j] + 1;
        final ins = dp[i][j - 1] + 1;
        final sub = dp[i - 1][j - 1] + 1;
        int best = del < ins ? del : ins;
        if (sub < best) best = sub;
        dp[i][j] = best;
      }
    }
  }
  return dp[m][n];
}

void main() {
  print(editDistance('kitten', 'sitting'));    // 3
  print(editDistance('flaw', 'lawn'));         // 2
  print(editDistance('intention', 'execution')); // 5
}
