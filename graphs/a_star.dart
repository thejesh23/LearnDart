import 'dart:collection';
import 'dart:math';

// A* pathfinding on a grid. Like Dijkstra but with a heuristic h(n)
// estimating the remaining cost to the goal. The priority queue
// orders nodes by f(n) = g(n) + h(n) — actual cost so far plus
// estimated cost to go.
//
// A* is guaranteed optimal if the heuristic is *admissible* (never
// overestimates) and *consistent* (satisfies the triangle
// inequality). Manhattan distance is both for grid movement with unit
// costs and cardinal neighbors — used here. On graphs with diagonal
// moves, use Chebyshev; for arbitrary Euclidean paths, use straight-
// line distance.
//
// The whole game-AI pathfinding industry runs on A* variants: HPA*
// for hierarchical maps, Jump Point Search for uniform-cost grids,
// D* Lite for changing environments. Complexity: O((V + E) log V)
// worst case; typically much better due to heuristic pruning.
List<(int, int)>? aStar(
    List<List<int>> grid, (int, int) start, (int, int) goal) {
  final rows = grid.length;
  final cols = grid[0].length;
  double h((int, int) p) =>
      ((p.$1 - goal.$1).abs() + (p.$2 - goal.$2).abs()).toDouble();

  final gScore = <(int, int), double>{start: 0};
  final cameFrom = <(int, int), (int, int)>{};
  final open = SplayTreeSet<(double, (int, int))>((a, b) {
    final c = a.$1.compareTo(b.$1);
    if (c != 0) return c;
    final d = a.$2.$1.compareTo(b.$2.$1);
    return d != 0 ? d : a.$2.$2.compareTo(b.$2.$2);
  })
    ..add((h(start), start));

  while (open.isNotEmpty) {
    final entry = open.first;
    open.remove(entry);
    final current = entry.$2;
    if (current == goal) {
      final path = <(int, int)>[current];
      var cur = current;
      while (cameFrom.containsKey(cur)) {
        cur = cameFrom[cur]!;
        path.add(cur);
      }
      return path.reversed.toList();
    }
    for (final (dr, dc) in const [(1, 0), (-1, 0), (0, 1), (0, -1)]) {
      final nr = current.$1 + dr;
      final nc = current.$2 + dc;
      if (nr < 0 || nr >= rows || nc < 0 || nc >= cols) continue;
      if (grid[nr][nc] == 1) continue;
      final neighbor = (nr, nc);
      final tentative = gScore[current]! + 1;
      if (tentative < (gScore[neighbor] ?? double.infinity)) {
        cameFrom[neighbor] = current;
        gScore[neighbor] = tentative;
        open.add((tentative + h(neighbor), neighbor));
      }
    }
  }
  return null;
}

void main() {
  final grid = [
    [0, 0, 0, 0, 1],
    [1, 1, 0, 1, 0],
    [0, 0, 0, 0, 0],
    [0, 1, 1, 1, 0],
    [0, 0, 0, 0, 0],
  ];
  print(aStar(grid, (0, 0), (4, 4)));
}
