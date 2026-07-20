// Greedy graph coloring (Welsh-Powell-style): sort vertices by descending
// degree, then assign each the smallest color that doesn't clash with a
// neighbor. Not always optimal — chromatic number is NP-hard.
Map<T, int> greedyColoring<T>(Map<T, List<T>> graph) {
  final order = graph.keys.toList()
    ..sort((a, b) => (graph[b]?.length ?? 0).compareTo(graph[a]?.length ?? 0));
  final color = <T, int>{};
  for (final v in order) {
    final used = <int>{};
    for (final u in graph[v] ?? const []) {
      final c = color[u];
      if (c != null) used.add(c);
    }
    int c = 0;
    while (used.contains(c)) c++;
    color[v] = c;
  }
  return color;
}

void main() {
  final graph = <String, List<String>>{
    'A': ['B', 'C', 'D'], 'B': ['A', 'C'], 'C': ['A', 'B', 'D'],
    'D': ['A', 'C', 'E'], 'E': ['D'],
  };
  print(greedyColoring(graph));
}
