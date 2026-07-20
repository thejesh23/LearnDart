// Knight's tour: visit every square of an n×n board exactly once. Simple
// backtracking — Warnsdorff's heuristic would let it scale further, but
// this suffices for small boards.
List<List<int>>? knightTour(int n, {(int, int) start = (0, 0)}) {
  const dr = [2, 1, -1, -2, -2, -1, 1, 2];
  const dc = [1, 2, 2, 1, -1, -2, -2, -1];
  final board = List.generate(n, (_) => List<int>.filled(n, -1));
  board[start.$1][start.$2] = 0;

  bool solve(int r, int c, int step) {
    if (step == n * n) return true;
    for (int k = 0; k < 8; k++) {
      final nr = r + dr[k];
      final nc = c + dc[k];
      if (nr >= 0 && nr < n && nc >= 0 && nc < n && board[nr][nc] == -1) {
        board[nr][nc] = step;
        if (solve(nr, nc, step + 1)) return true;
        board[nr][nc] = -1;
      }
    }
    return false;
  }

  return solve(start.$1, start.$2, 1) ? board : null;
}

void main() {
  final tour = knightTour(5, start: (0, 0));
  if (tour == null) print('no tour found');
  else {
    for (final row in tour) print(row.map((v) => v.toString().padLeft(2)).join(' '));
  }
}
