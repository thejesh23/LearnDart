// One tick of Conway's Game of Life on an m×n grid. Rules:
//   - live cell with 2 or 3 live neighbors survives
//   - dead cell with exactly 3 live neighbors is born
//   - all other cells die or stay dead
List<List<int>> gameOfLifeStep(List<List<int>> grid) {
  final m = grid.length;
  final n = grid[0].length;
  final next = List.generate(m, (_) => List<int>.filled(n, 0));
  for (int i = 0; i < m; i++) {
    for (int j = 0; j < n; j++) {
      int live = 0;
      for (int di = -1; di <= 1; di++) {
        for (int dj = -1; dj <= 1; dj++) {
          if (di == 0 && dj == 0) continue;
          final ni = i + di;
          final nj = j + dj;
          if (ni >= 0 && ni < m && nj >= 0 && nj < n) live += grid[ni][nj];
        }
      }
      next[i][j] = (grid[i][j] == 1 && (live == 2 || live == 3)) ||
              (grid[i][j] == 0 && live == 3)
          ? 1 : 0;
    }
  }
  return next;
}

String _draw(List<List<int>> g) =>
    g.map((row) => row.map((c) => c == 1 ? '#' : '.').join()).join('\n');

void main() {
  // Blinker oscillator — period 2.
  var grid = [
    [0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0],
    [0, 1, 1, 1, 0],
    [0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0],
  ];
  for (int step = 0; step < 3; step++) {
    print('step $step:\n${_draw(grid)}\n');
    grid = gameOfLifeStep(grid);
  }
}
