import 'dart:collection';
import 'dart:math';

// A* on a grid. `grid[r][c] == 0` is walkable, `1` is blocked. Uses
// Manhattan distance as the heuristic.
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
