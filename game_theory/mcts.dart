// Monte Carlo Tree Search (MCTS) with UCB1 selection — the algorithm
// behind AlphaGo, many modern board-game engines, and countless
// combinatorial optimisation solvers. Unlike minimax it requires no
// domain-specific evaluation function: it estimates node value by
// running random *rollouts* to terminal states and averaging results.
//
// Four phases per iteration:
//   1. Selection  — descend the tree using UCB1 until a node with
//                   unexpanded children is reached.
//   2. Expansion  — create one new child for an untried move.
//   3. Simulation — play the game with random moves to a terminal.
//   4. Backprop   — propagate the result up to the root, updating
//                   visit counts and win totals at every ancestor.
//
// UCB1 formula for selecting among a node's children:
//   score(child) = wins(child)/visits(child)
//                + C * sqrt(ln(visits(parent)) / visits(child))
//   The first term exploits known-good moves; the second explores
//   under-visited ones. C = √2 is the theoretically optimal constant.
//
// After `iterations`, the child with the most visits is chosen
// (visits, not win rate, for robustness to outliers).
//
// This file uses tic-tac-toe as the game; swap the three
// game-interface functions (_moves, _applyMove, _terminal) to
// plug in any two-player zero-sum game.
//
// Result from X's perspective throughout: +1 win, –1 loss, 0 draw.

import 'dart:math';

const _X = 1, _O = -1, _E = 0;

const _lines = [
  [0,1,2],[3,4,5],[6,7,8],
  [0,3,6],[1,4,7],[2,5,8],
  [0,4,8],[2,4,6],
];

int? _winner(List<int> b) {
  for (final l in _lines) {
    if (b[l[0]] != _E && b[l[0]] == b[l[1]] && b[l[1]] == b[l[2]]) return b[l[0]];
  }
  return null;
}

List<int> _moves(List<int> b) =>
    [for (int i = 0; i < 9; i++) if (b[i] == _E) i];

// Rollout outcome from X's perspective (±1, 0).
double _rollout(List<int> board, int player, Random rng) {
  final b = List<int>.from(board);
  int p = player;
  while (true) {
    final w = _winner(b);
    if (w != null) return w.toDouble();
    final m = _moves(b);
    if (m.isEmpty) return 0.0;
    b[m[rng.nextInt(m.length)]] = p;
    p = -p;
  }
}

class _Node {
  final List<int> board;
  final int player;       // whose turn it is TO PLAY from this node
  final _Node? parent;
  final int? move;        // the move that created this node (null for root)
  final children = <_Node>[];
  final untried = <int>[];  // moves not yet expanded
  double wins = 0;          // cumulative result from X's perspective
  int visits = 0;

  _Node(this.board, this.player, this.parent, this.move) {
    untried.addAll(_moves(board));
  }

  bool get isTerminal => _winner(board) != null || untried.isEmpty && children.isEmpty;

  // UCB1 score from the perspective of the node's player.
  // The sign flips so MAX nodes pick high-win children and MIN nodes
  // pick low-win (for X) children — both maximise their own utility.
  double ucb1(double c) {
    final sign = parent!.player == _X ? 1.0 : -1.0;
    return sign * wins / visits + c * sqrt(log(parent!.visits) / visits);
  }

  _Node bestChild(double c) =>
      children.reduce((a, b) => a.ucb1(c) >= b.ucb1(c) ? a : b);

  _Node expand(Random rng) {
    final m = untried.removeAt(rng.nextInt(untried.length));
    final nb = List<int>.from(board)..[m] = player;
    final child = _Node(nb, -player, this, m);
    children.add(child);
    return child;
  }
}

void _backprop(_Node node, double result) {
  _Node? n = node;
  while (n != null) {
    n.visits++;
    n.wins += result;  // result is always from X's perspective
    n = n.parent;
  }
}

/// Returns the index (0–8) of the best move for [player] on [board].
int mcts(List<int> board, int player, {int iterations = 1000, Random? rng}) {
  rng ??= Random();
  final root = _Node(List<int>.from(board), player, null, null);

  for (int i = 0; i < iterations; i++) {
    // 1. Selection
    _Node node = root;
    while (node.untried.isEmpty && node.children.isNotEmpty && !node.isTerminal) {
      node = node.bestChild(sqrt(2));
    }
    // 2. Expansion
    if (node.untried.isNotEmpty && _winner(node.board) == null) {
      node = node.expand(rng);
    }
    // 3. Simulation
    final result = _rollout(node.board, node.player, rng);
    // 4. Backpropagation
    _backprop(node, result);
  }

  return root.children
      .reduce((a, b) => a.visits >= b.visits ? a : b)
      .move!;
}

String _render(List<int> b) {
  const sym = {_X: 'X', _O: 'O', _E: '.'};
  return [0,3,6].map((r) => b.sublist(r,r+3).map((c) => sym[c]).join(' ')).join('\n');
}

void main() {
  final rng = Random(42);
  final board = List<int>.filled(9, _E);
  int player = _X;

  print('MCTS tic-tac-toe (both sides, 800 iterations each)\n');
  while (_winner(board) == null && _moves(board).isNotEmpty) {
    final move = mcts(board, player, iterations: 800, rng: rng);
    board[move] = player;
    print('${player == _X ? "X" : "O"} → index $move\n${_render(board)}\n');
    player = -player;
  }
  final w = _winner(board);
  print(w == null ? 'Draw (near-perfect play with 800 iterations)' : '${w == _X ? "X" : "O"} wins');
}
