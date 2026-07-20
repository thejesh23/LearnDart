import 'dart:collection';

// Bidirectional BFS: two frontiers grow outward from `start` and `goal`
// simultaneously; when they meet, an unweighted shortest path exists.
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
