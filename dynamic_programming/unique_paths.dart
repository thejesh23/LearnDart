// Count paths from top-left to bottom-right of an m×n grid moving only
// right or down. Classic 2-D DP; space-optimized to a single row.
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
