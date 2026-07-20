// Hierholzer's algorithm: find an Eulerian circuit — a closed walk
// that uses every edge exactly once and returns to start.
//
// Existence criteria (Euler, 1736): the graph must be connected on
// its non-isolated vertices, and every vertex must have *even*
// degree. That last condition is famously why the Seven Bridges of
// Königsberg puzzle has no solution — three of the four land masses
// had odd degree.
//
// The algorithm: walk from any starting vertex, following unused
// edges arbitrarily until you get stuck (which must be back at the
// start, given even degrees). If you missed edges, splice in a
// sub-tour by restarting at any visited vertex with unused edges.
// The stack-based implementation folds both phases into one loop.
//
// Complexity: O(V + E). Applications: DNA sequencing (assembly by
// finding Eulerian paths in the de Bruijn graph), snowplow route
// planning, delivery routing.
List<int>? eulerianCircuit(int n, List<(int, int)> edges) {
  final adj = <int, List<int>>{for (int i = 0; i < n; i++) i: []};
  for (final (u, v) in edges) {
    adj[u]!.add(v);
    adj[v]!.add(u);
  }
  for (final outs in adj.values) {
    if (outs.length.isOdd) return null;
  }

  // Track how many edges have been consumed at each vertex via an index.
  final nextIdx = List<int>.filled(n, 0);
  final usedEdges = <int>{}; // edge id: min*n + max
  int edgeId(int a, int b) => (a < b ? a : b) * (n + 1) + (a < b ? b : a);

  int start = 0;
  for (int i = 0; i < n; i++) {
    if (adj[i]!.isNotEmpty) { start = i; break; }
  }

  final stack = <int>[start];
  final circuit = <int>[];
  while (stack.isNotEmpty) {
    final v = stack.last;
    int? next;
    while (nextIdx[v] < adj[v]!.length) {
      final candidate = adj[v]![nextIdx[v]++];
      final id = edgeId(v, candidate);
      if (!usedEdges.contains(id)) {
        usedEdges.add(id);
        next = candidate;
        break;
      }
    }
    if (next == null) {
      circuit.add(stack.removeLast());
    } else {
      stack.add(next);
    }
  }
  return circuit.reversed.toList();
}

void main() {
  final edges = <(int, int)>[
    (0, 1), (1, 2), (2, 0), (2, 3), (3, 4), (4, 2),
  ];
  print(eulerianCircuit(5, edges));
}
