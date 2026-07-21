// Alpha-beta pruning — minimax with early termination. Maintains two
// bounds that together define a window of interest:
//   α = best score MAX can guarantee from the root so far.
//   β = best score MIN can guarantee from the root so far.
//
// Pruning rules:
//   At a MAX node: if a child's score ≥ β, MIN would never let play
//   reach this node → cut off (β-cutoff).
//   At a MIN node: if a child's score ≤ α, MAX would never let play
//   reach this node → cut off (α-cutoff).
//
// Result: always identical to plain minimax. No search quality lost —
// only branches that *cannot* affect the outcome are skipped.
//
// Efficiency:
//   Best case (perfect move ordering): O(b^(d/2)).
//     Effective branching factor is √b — like searching twice as deep
//     as minimax for the same node budget.
//   Worst case (reverse ordering): O(b^d) — same as minimax.
//   Average (random ordering): O(b^(3d/4)).
//
// Move ordering is therefore the key lever. This file uses index order
// to stay readable; real engines sort by history heuristic, killer
// moves, or a shallow static evaluation first.
//
// `nodesVisited` lets you compare with game_theory/minimax.dart.

const _X = 1, _O = -1, _E = 0;

const _lines = [
  [0,1,2],[3,4,5],[6,7,8],
  [0,3,6],[1,4,7],[2,5,8],
  [0,4,8],[2,4,6],
];

int nodesVisited = 0;

int? _winner(List<int> b) {
  for (final l in _lines) {
    if (b[l[0]] != _E && b[l[0]] == b[l[1]] && b[l[1]] == b[l[2]]) return b[l[0]];
  }
  return null;
}

bool _full(List<int> b) => !b.contains(_E);

// Returns the minimax value of [b] for [player] with α-β bounds.
// alpha: the minimum score MAX is already guaranteed.
// beta:  the maximum score MIN is already guaranteed.
int _alphaBeta(List<int> b, int player, int alpha, int beta) {
  nodesVisited++;
  final w = _winner(b);
  if (w != null) return w;
  if (_full(b)) return 0;

  for (int i = 0; i < 9; i++) {
    if (b[i] != _E) continue;
    b[i] = player;
    final score = _alphaBeta(b, -player, alpha, beta);
    b[i] = _E;
    if (player == _X) {
      if (score > alpha) alpha = score;
      if (alpha >= beta) break;  // β cut-off — MIN won't allow this
    } else {
      if (score < beta) beta = score;
      if (beta <= alpha) break;  // α cut-off — MAX won't play here
    }
  }
  return player == _X ? alpha : beta;
}

int bestMove(List<int> b, int player) {
  int bestScore = player == _X ? -2 : 2;
  int bestIdx = -1;
  nodesVisited = 0;
  for (int i = 0; i < 9; i++) {
    if (b[i] != _E) continue;
    b[i] = player;
    final score = _alphaBeta(b, -player, -2, 2);
    b[i] = _E;
    if (player == _X ? score > bestScore : score < bestScore) {
      bestScore = score; bestIdx = i;
    }
  }
  return bestIdx;
}

String _render(List<int> b) {
  const sym = {_X: 'X', _O: 'O', _E: '.'};
  return [0,3,6].map((r) => b.sublist(r,r+3).map((c) => sym[c]).join(' ')).join('\n');
}

void main() {
  // Same position as minimax.dart — compare node counts.
  final board = [
    _X, _O, _E,
    _E, _X, _E,
    _O, _E, _E,
  ];
  print('Board:\n${_render(board)}\n');
  final move = bestMove(board, _X);
  print('X plays index $move');
  print('Nodes visited: $nodesVisited');

  // From empty board — stark difference vs minimax (~250k nodes).
  nodesVisited = 0;
  final empty = List<int>.filled(9, _E);
  final m0 = bestMove(empty, _X);
  print('\nFrom empty board: X plays index $m0, nodes visited: $nodesVisited');
  // α-β typically visits ≈10k–30k nodes vs minimax's ~250k from empty board.
}
