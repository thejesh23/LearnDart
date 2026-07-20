// Max Area of Island: given a 2-D grid of 0s (water) and 1s (land),
// return the size of the largest connected land-mass. Connectivity
// is 4-directional (up/down/left/right).
//
// This is a classic flood-fill problem — the underlying graph has
// one vertex per cell and an edge between every pair of adjacent
// cells that are both land. We visit every cell once, so the run
// is O(R·C) time and O(R·C) space for the visited grid (or the
// recursion stack of iterative-DFS, whichever we choose).
//
// Two idiomatic ways to fill:
//   - Recursive DFS (simple, but risks stack overflow on huge grids).
//   - Iterative DFS with an explicit stack (bulletproof).
// This file uses the iterative form, matching graphs/dfs.dart.
//
// Real uses: counting islands (LeetCode #200), image-processing
// connected-component labelling, level-editor room detection,
// terrain analysis in GIS.
int maxAreaOfIsland(List<List<int>> grid) {
  if (grid.isEmpty || grid[0].isEmpty) return 0;
  final rows = grid.length, cols = grid[0].length;
  final visited = List.generate(rows, (_) => List<bool>.filled(cols, false));
  const dr = [-1, 1, 0, 0];
  const dc = [0, 0, -1, 1];
  int best = 0;
  for (int r = 0; r < rows; r++) {
    for (int c = 0; c < cols; c++) {
      if (grid[r][c] == 0 || visited[r][c]) continue;
      int area = 0;
      final stack = <List<int>>[[r, c]];
      while (stack.isNotEmpty) {
        final cell = stack.removeLast();
        final cr = cell[0], cc = cell[1];
        if (cr < 0 || cr >= rows || cc < 0 || cc >= cols) continue;
        if (visited[cr][cc] || grid[cr][cc] == 0) continue;
        visited[cr][cc] = true;
        area++;
        for (int k = 0; k < 4; k++) stack.add([cr + dr[k], cc + dc[k]]);
      }
      if (area > best) best = area;
    }
  }
  return best;
}

void main() {
  print(maxAreaOfIsland([
    [0, 0, 1, 0, 0],
    [0, 0, 0, 0, 0],
    [0, 1, 1, 0, 0],
    [0, 1, 0, 0, 0],
  ])); // 3

  print(maxAreaOfIsland([
    [1, 1, 0, 0, 0],
    [1, 1, 0, 0, 0],
    [0, 0, 0, 1, 1],
    [0, 0, 0, 1, 1],
  ])); // 4
}
