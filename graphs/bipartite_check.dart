// Test whether a graph is bipartite — can be split into two disjoint
// vertex sets so every edge crosses between them. Equivalently: is
// the graph 2-colorable? Equivalently: does it contain no odd cycle?
//
// BFS with two-coloring: color the start vertex 0, its neighbors 1,
// their neighbors 0 again, and so on. If a neighbor is already
// colored the same as its parent, an odd cycle exists and the graph
// is not bipartite.
//
// Bipartiteness enables specialized algorithms: bipartite matching
// (Hopcroft-Karp, König's theorem), stable matching (Gale-Shapley),
// and cleaner spectral properties. Non-bipartite matching (general
// graphs) is much harder — Edmonds' blossom algorithm.
//
// Complexity: O(V + E) time and space.

import 'dart:collection';
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
