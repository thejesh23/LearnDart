// Validate a completed 9×9 sudoku board: every row, column, and 3×3 box
// must contain the digits 1..9 exactly once. Zero denotes empty; treat
// any zero as invalid for a completed-board check.
//
// Three passes through the grid — one for rows, one for columns, one for
// the nine 3×3 sub-boxes. Each pass uses a Set to detect duplicates in
// O(1); if `Set.add` ever returns false, the board is invalid.
//
// This is the *validation* problem, not the *solving* problem. The solver
// (a backtracking search) lives in backtracking/sudoku_solver.dart. A
// solver would call this validator on partial states, or (more commonly)
// use the same row/column/box constraint checks inline as it recurses.
//
// Complexity: O(81) time — the board is a fixed 9×9, so this is effectively
// constant work. Space: O(9) per Set.
bool isValidSudoku(List<List<int>> board) {
  for (int i = 0; i < 9; i++) {
    final row = <int>{};
    final col = <int>{};
    for (int j = 0; j < 9; j++) {
      if (board[i][j] < 1 || board[i][j] > 9 || !row.add(board[i][j])) return false;
      if (board[j][i] < 1 || board[j][i] > 9 || !col.add(board[j][i])) return false;
    }
  }
  for (int br = 0; br < 3; br++) {
    for (int bc = 0; bc < 3; bc++) {
      final box = <int>{};
      for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 3; j++) {
          final v = board[br * 3 + i][bc * 3 + j];
          if (!box.add(v)) return false;
        }
      }
    }
  }
  return true;
}

void main() {
  final valid = [
    [5, 3, 4, 6, 7, 8, 9, 1, 2],
    [6, 7, 2, 1, 9, 5, 3, 4, 8],
    [1, 9, 8, 3, 4, 2, 5, 6, 7],
    [8, 5, 9, 7, 6, 1, 4, 2, 3],
    [4, 2, 6, 8, 5, 3, 7, 9, 1],
    [7, 1, 3, 9, 2, 4, 8, 5, 6],
    [9, 6, 1, 5, 3, 7, 2, 8, 4],
    [2, 8, 7, 4, 1, 9, 6, 3, 5],
    [3, 4, 5, 2, 8, 6, 1, 7, 9],
  ];
  print(isValidSudoku(valid)); // true

  final broken = List.generate(9, (i) => List<int>.of(valid[i]));
  broken[0][0] = 1;
  print(isValidSudoku(broken)); // false (duplicate 1 in row 0)
}
