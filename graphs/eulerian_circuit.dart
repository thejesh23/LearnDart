// Hierholzer's algorithm: find an Eulerian circuit — a closed walk that
// uses every edge exactly once. Requires every vertex to have even degree
// and the graph (on non-isolated vertices) to be connected.
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
