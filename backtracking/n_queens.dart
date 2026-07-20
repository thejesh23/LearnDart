// Place n queens on an n×n chessboard so no two share a row, column, or
// diagonal. Return every valid arrangement.
//
// The canonical backtracking demo. Because no two queens can share a row,
// we know exactly one queen per row — so the state is just an int per
// row saying which column the queen sits in. The `safe` check runs in
// O(row) by comparing the candidate against all rows already filled.
//
// Two diagonals per pair: "same slope" iff (r1 - c1) == (r2 - c2), and
// "opposite slope" iff (r1 + c1) == (r2 + c2). Both fit in one line each.
//
// Complexity: the search tree is bounded but grows fast — n=8 has 92
// solutions, n=14 has 365,596. For much larger n, use bit-packed
// column/diagonal masks and per-row branching.
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
