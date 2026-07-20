// Breadth-First Search: visit nodes in layers of increasing distance
// from the start. Uses a FIFO queue: nodes are enqueued as they're
// discovered and dequeued to expand their neighbors.
//
// The visited set is essential — it prevents revisiting nodes in
// cyclic graphs. `visited.add(n)` returns false on duplicates, so
// one line handles the "seen?" check and the "mark seen" update.
//
// BFS finds the *shortest path in edge count* on unweighted graphs.
// For weighted graphs use Dijkstra (graphs/dijkstra.dart). For deeper
// search with less memory, DFS (graphs/dfs.dart); for the goal-
// directed variant that uses a heuristic, A* (graphs/a_star.dart).
//
// Complexity: O(V + E) time and space.

import 'dart:collection';

List<T> bfs<T>(Map<T, List<T>> graph, T start) {
  final visited = <T>{start};
  final order = <T>[];
  final queue = Queue<T>()..add(start);
  while (queue.isNotEmpty) {
    final node = queue.removeFirst();
    order.add(node);
    for (final n in graph[node] ?? const []) {
      if (visited.add(n)) queue.add(n);
    }
  }
  return order;
}

void main() {
  final graph = <String, List<String>>{
    'A': ['B', 'C'],
    'B': ['A', 'D', 'E'],
    'C': ['A', 'F'],
    'D': ['B'],
    'E': ['B', 'F'],
    'F': ['C', 'E'],
  };
  print(bfs(graph, 'A')); // [A, B, C, D, E, F]
}
