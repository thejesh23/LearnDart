// Count paths from top-left to bottom-right of an m×n grid moving
// only right or down.
//
// The natural 2-D DP is dp[i][j] = dp[i-1][j] + dp[i][j-1], filled
// row by row. Space-optimizes to a single row because each cell only
// depends on the one above (last iteration's value in that column)
// and the one to the left (this iteration's value already computed).
//
// Closed form via combinatorics: to get from (0,0) to (m-1,n-1) you
// take m-1 down moves and n-1 right moves in any order, so the answer
// is C(m+n-2, m-1) — see maths/binomial_coefficient.dart for the
// direct formula.
//
// Complexity: O(m · n) time, O(n) space. Or O(1) via the formula.
int uniquePaths(int m, int n) {
  if (m <= 0 || n <= 0) return 0;
  final row = List<int>.filled(n, 1);
  for (int i = 1; i < m; i++) {
    for (int j = 1; j < n; j++) {
      row[j] += row[j - 1];
    }
  }
  return row[n - 1];
}

void main() {
  print(uniquePaths(3, 7));  // 28
  print(uniquePaths(3, 2));  // 3
  print(uniquePaths(7, 3));  // 28
}
