// Greedy graph coloring: assign each vertex the smallest color number
// that doesn't clash with an already-colored neighbor.
//
// Vertex ordering matters — Welsh-Powell sorts by descending degree,
// often producing near-optimal colorings. Other orderings (random,
// smallest-degree-last) work too; there's no ordering that
// guarantees optimality for all graphs.
//
// Finding the chromatic number (the true minimum) is NP-hard, so
// greedy is the pragmatic choice for scheduling problems: exam
// timetabling, register allocation in compilers (two variables that
// might be alive simultaneously get different colors = different
// registers), Sudoku (as constraint satisfaction), radio-tower
// frequency assignment, map coloring.
//
// Complexity: O(V^2 + E) time, O(V) space.
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
