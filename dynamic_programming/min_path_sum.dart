// Minimum-cost path from top-left to bottom-right, moving only right or
// down. In-place DP: overwrite the grid with cumulative minima.
int minPathSum(List<List<int>> grid) {
  final m = grid.length;
  if (m == 0) return 0;
  final n = grid[0].length;
  for (int i = 0; i < m; i++) {
    for (int j = 0; j < n; j++) {
      if (i == 0 && j == 0) continue;
      if (i == 0) {
        grid[i][j] += grid[i][j - 1];
      } else if (j == 0) {
        grid[i][j] += grid[i - 1][j];
      } else {
        final up = grid[i - 1][j];
        final left = grid[i][j - 1];
        grid[i][j] += up < left ? up : left;
      }
    }
  }
  return grid[m - 1][n - 1];
}

void main() {
  print(minPathSum([[1,3,1],[1,5,1],[4,2,1]]));  // 7
  print(minPathSum([[1,2,3],[4,5,6]]));          // 12
}
