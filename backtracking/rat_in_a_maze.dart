// Find all paths from (0,0) to (n-1,n-1) moving only D/R/U/L in a grid
// where 1 = walkable, 0 = blocked.
List<String> ratInAMaze(List<List<int>> maze) {
  final n = maze.length;
  final visited = List.generate(n, (_) => List<bool>.filled(n, false));
  final paths = <String>[];

  const dr = [1, 0, 0, -1];
  const dc = [0, -1, 1, 0];
  const dirs = 'DLRU';

  void walk(int r, int c, String trail) {
    if (r == n - 1 && c == n - 1) {
      paths.add(trail);
      return;
    }
    visited[r][c] = true;
    for (int i = 0; i < 4; i++) {
      final nr = r + dr[i];
      final nc = c + dc[i];
      if (nr >= 0 && nr < n && nc >= 0 && nc < n &&
          maze[nr][nc] == 1 && !visited[nr][nc]) {
        walk(nr, nc, trail + dirs[i]);
      }
    }
    visited[r][c] = false;
  }

  if (maze[0][0] == 1) walk(0, 0, '');
  return paths;
}

void main() {
  final maze = [
    [1, 0, 0, 0],
    [1, 1, 0, 1],
    [1, 1, 0, 0],
    [0, 1, 1, 1],
  ];
  print(ratInAMaze(maze)); // [DDRDRR, DRDDRR]
}
