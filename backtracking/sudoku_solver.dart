// Classic 9×9 sudoku solver via backtracking. Zero denotes an empty cell.
//
// For each empty cell, try digits 1..9; for each digit, check it doesn't
// clash with the same row, column, or 3×3 box (that's what `_isValid`
// does); recurse; if the recursion fails, undo the placement and try the
// next digit. If no digit works, back up to the previous cell.
//
// A well-formed sudoku has a unique solution, so this returns as soon
// as one is found. Real-world solvers add constraint propagation
// (naked singles, hidden pairs, etc.) to shrink the search tree before
// they ever guess — often turning a puzzle into pure inference with no
// backtracking at all. See puzzles/sudoku_validator.dart for just the
// validity check.
//
// Complexity: exponential in the worst case; typically instant on
// human-designed puzzles.
bool solveSudoku(List<List<int>> board) {
  for (int r = 0; r < 9; r++) {
    for (int c = 0; c < 9; c++) {
      if (board[r][c] != 0) continue;
      for (int v = 1; v <= 9; v++) {
        if (_isValid(board, r, c, v)) {
          board[r][c] = v;
          if (solveSudoku(board)) return true;
          board[r][c] = 0;
        }
      }
      return false;
    }
  }
  return true;
}

bool _isValid(List<List<int>> b, int r, int c, int v) {
  for (int i = 0; i < 9; i++) {
    if (b[r][i] == v || b[i][c] == v) return false;
  }
  final br = (r ~/ 3) * 3;
  final bc = (c ~/ 3) * 3;
  for (int i = 0; i < 3; i++) {
    for (int j = 0; j < 3; j++) {
      if (b[br + i][bc + j] == v) return false;
    }
  }
  return true;
}

void main() {
  final board = [
    [5,3,0,0,7,0,0,0,0],
    [6,0,0,1,9,5,0,0,0],
    [0,9,8,0,0,0,0,6,0],
    [8,0,0,0,6,0,0,0,3],
    [4,0,0,8,0,3,0,0,1],
    [7,0,0,0,2,0,0,0,6],
    [0,6,0,0,0,0,2,8,0],
    [0,0,0,4,1,9,0,0,5],
    [0,0,0,0,8,0,0,7,9],
  ];
  solveSudoku(board);
  for (final row in board) print(row);
}
