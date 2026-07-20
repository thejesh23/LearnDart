// Bidirectional BFS: run BFS from *both* endpoints simultaneously
// and stop when the two frontiers meet.
//
// The big win: a BFS to depth d explores O(b^d) nodes; two BFS runs
// each to depth d/2 explore O(2·b^(d/2)) — exponentially smaller for
// non-trivial d. Essential technique for pathfinding in massive
// graphs (social-network degree-of-separation queries, road maps).
//
// Reconstructing the path requires stitching two half-paths together
// at the meeting node — that's what the `left` and `right` walks do.
// Assumes unweighted edges; for weighted graphs use bidirectional
// Dijkstra, which is trickier because the two frontiers must
// coordinate on when to stop safely.
//
// Complexity: O(b^(d/2)) instead of O(b^d).

import 'dart:collection';
List<T>? bidirectionalSearch<T>(
    Map<T, List<T>> graph, T start, T goal) {
  if (start == goal) return [start];
  final fromStart = <T, T?>{start: null};
  final fromGoal = <T, T?>{goal: null};
  final qs = Queue<T>()..add(start);
  final qg = Queue<T>()..add(goal);

  T? meet;
  while (qs.isNotEmpty && qg.isNotEmpty && meet == null) {
    meet = _expandFrontier(graph, qs, fromStart, fromGoal);
    if (meet != null) break;
    meet = _expandFrontier(graph, qg, fromGoal, fromStart);
  }
  if (meet == null) return null;

  final path = <T>[];
  T? cur = meet;
  while (cur != null) { path.add(cur); cur = fromStart[cur]; }
  final left = path.reversed.toList();
  final right = <T>[];
  cur = fromGoal[meet];
  while (cur != null) { right.add(cur); cur = fromGoal[cur]; }
  return [...left, ...right];
}

T? _expandFrontier<T>(Map<T, List<T>> graph, Queue<T> frontier,
    Map<T, T?> visited, Map<T, T?> other) {
  final size = frontier.length;
  for (int i = 0; i < size; i++) {
    final u = frontier.removeFirst();
    for (final v in graph[u] ?? const []) {
      if (visited.containsKey(v)) continue;
      visited[v] = u;
      if (other.containsKey(v)) return v;
      frontier.add(v);
    }
  }
  return null;
}

void main() {
  final graph = <String, List<String>>{
    'A': ['B', 'C'], 'B': ['A', 'D'], 'C': ['A', 'D'], 'D': ['B', 'C', 'E'],
    'E': ['D', 'F'], 'F': ['E'],
  };
  print(bidirectionalSearch(graph, 'A', 'F'));
}
