// Place n queens on an n×n board so no two attack each other.
List<List<int>> solveNQueens(int n) {
  final solutions = <List<int>>[];
  final cols = List<int>.filled(n, -1);

  bool safe(int row, int col) {
    for (int r = 0; r < row; r++) {
      final c = cols[r];
      if (c == col || (r - c) == (row - col) || (r + c) == (row + col)) {
        return false;
      }
    }
    return true;
  }

  void place(int row) {
    if (row == n) {
      solutions.add(List<int>.of(cols));
      return;
    }
    for (int col = 0; col < n; col++) {
      if (safe(row, col)) {
        cols[row] = col;
        place(row + 1);
      }
    }
  }

  place(0);
  return solutions;
}

void main() {
  final solutions = solveNQueens(4);
  print('4-queens has ${solutions.length} solutions:');
  for (final s in solutions) print(s);
  print('8-queens count: ${solveNQueens(8).length}');
}
