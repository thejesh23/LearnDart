// Minimax — the foundational algorithm for optimal play in two-player
// zero-sum games. One player (MAX) maximises the score; the other
// (MIN) minimises it. The search exhausts the game tree recursively,
// bottoming out at terminal positions with a fixed score.
//
// Assumption: both players play perfectly. The returned score and move
// guarantee the best possible outcome against a perfect opponent.
//
// Board encoding for tic-tac-toe:
//   9 integers in row-major order (indices 0–8).
//   +1 = X (maximiser),  –1 = O (minimiser),  0 = empty.
//
// Score convention: +1 X wins, –1 O wins, 0 draw.
//
// Fact: perfect play in tic-tac-toe always ends in a draw.
//
// Complexity: O(b^d) — branching factor b ≤ 9, depth d ≤ 9, so at
// most ~362 880 terminal leaves. Fast enough to be instant, but this
// explodes for larger games (chess has b ≈ 35, d ≈ 80). See
// game_theory/alpha_beta_pruning.dart for the practical optimisation.

const _X = 1, _O = -1, _E = 0;

const _lines = [
  [0,1,2],[3,4,5],[6,7,8],  // rows
  [0,3,6],[1,4,7],[2,5,8],  // cols
  [0,4,8],[2,4,6],           // diagonals
];

int? _winner(List<int> b) {
  for (final l in _lines) {
    if (b[l[0]] != _E && b[l[0]] == b[l[1]] && b[l[1]] == b[l[2]]) return b[l[0]];
  }
  return null;
}

bool _full(List<int> b) => !b.contains(_E);

int _minimax(List<int> b, int player) {
  final w = _winner(b);
  if (w != null) return w;
  if (_full(b)) return 0;

  int best = player == _X ? -2 : 2;
  for (int i = 0; i < 9; i++) {
    if (b[i] != _E) continue;
    b[i] = player;
    final score = _minimax(b, -player);
    b[i] = _E;
    if (player == _X ? score > best : score < best) best = score;
  }
  return best;
}

/// Returns the index (0–8) of the best move for [player].
int bestMove(List<int> b, int player) {
  int bestScore = player == _X ? -2 : 2;
  int bestIdx = -1;
  for (int i = 0; i < 9; i++) {
    if (b[i] != _E) continue;
    b[i] = player;
    final score = _minimax(b, -player);
    b[i] = _E;
    if (player == _X ? score > bestScore : score < bestScore) {
      bestScore = score; bestIdx = i;
    }
  }
  return bestIdx;
}

String _render(List<int> b) {
  const sym = {_X: 'X', _O: 'O', _E: '.'};
  return [0, 3, 6]
      .map((r) => b.sublist(r, r + 3).map((c) => sym[c]).join(' '))
      .join('\n');
}

void main() {
  // X to play — diagonal already formed, must take index 7 to win.
  final board = [
    _X, _O, _E,
    _E, _X, _E,
    _O, _E, _E,
  ];
  print('Board:\n${_render(board)}\n');
  final move = bestMove(board, _X);
  board[move] = _X;
  print('X plays index $move:\n${_render(board)}');
  print('Result: ${_winner(board) == _X ? "X wins" : "game continues"}');

  // Also show that X never loses from the empty board.
  print('\n--- Full game: X (minimax) vs O (minimax) ---');
  final g = List<int>.filled(9, _E);
  int p = _X;
  while (_winner(g) == null && !_full(g)) {
    final m = bestMove(g, p);
    g[m] = p;
    p = -p;
  }
  print(_render(g));
  final w = _winner(g);
  print(w == null ? 'Draw (as expected with perfect play)' : '${w == _X ? "X" : "O"} wins');
}
