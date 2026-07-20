import 'dart:collection';

// A graph is bipartite iff it is 2-colorable — every edge connects nodes
// of opposite colors. BFS with alternating colors decides in O(V + E).
bool isBipartite<T>(Map<T, List<T>> graph) {
  final color = <T, int>{};
  for (final start in graph.keys) {
    if (color.containsKey(start)) continue;
    color[start] = 0;
    final queue = Queue<T>()..add(start);
    while (queue.isNotEmpty) {
      final u = queue.removeFirst();
      for (final v in graph[u] ?? const []) {
        if (!color.containsKey(v)) {
          color[v] = 1 - color[u]!;
          queue.add(v);
        } else if (color[v] == color[u]) {
          return false;
        }
      }
    }
  }
  return true;
}

void main() {
  final bipartite = <String, List<String>>{
    'A': ['B', 'D'], 'B': ['A', 'C'], 'C': ['B', 'D'], 'D': ['A', 'C'],
  };
  final triangle = <String, List<String>>{
    'A': ['B', 'C'], 'B': ['A', 'C'], 'C': ['A', 'B'],
  };
  print(isBipartite(bipartite));  // true
  print(isBipartite(triangle));   // false
}
