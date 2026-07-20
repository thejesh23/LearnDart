// Grid DP: find the minimum-cost path from top-left to bottom-right
// of a grid, moving only right or down at each step.
//
// DP recurrence: dp[i][j] = grid[i][j] + min(dp[i-1][j], dp[i][j-1]).
// Border cells only have one predecessor. Because we walk the grid
// top-to-bottom, left-to-right, we can safely overwrite grid[i][j]
// with its cumulative minimum in place — no separate DP array needed.
//
// Cousin problems:
//   - unique_paths.dart (count paths rather than min cost)
//   - "max score" (flip min → max, keep the rest)
//   - "min falling path" (three predecessors instead of two)
// The shape is the same; only the transition operator changes.
//
// Complexity: O(m · n) time, O(1) extra space (in-place).
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
