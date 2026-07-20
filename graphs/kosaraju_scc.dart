// Kosaraju's algorithm: two DFS passes to find strongly connected
// components. First pass records finish order; second walks the reverse
// graph in reverse finish order, each traversal collecting one SCC.
List<List<int>> kosarajuSCC(int n, Map<int, List<int>> graph) {
  final visited = List<bool>.filled(n, false);
  final finishOrder = <int>[];

  void dfs1(int v) {
    visited[v] = true;
    for (final w in graph[v] ?? const []) {
      if (!visited[w]) dfs1(w);
    }
    finishOrder.add(v);
  }

  for (int v = 0; v < n; v++) {
    if (!visited[v]) dfs1(v);
  }

  final reverse = <int, List<int>>{for (int i = 0; i < n; i++) i: []};
  graph.forEach((u, outs) {
    for (final v in outs) reverse[v]!.add(u);
  });

  final assigned = List<bool>.filled(n, false);
  final sccs = <List<int>>[];

  void dfs2(int v, List<int> comp) {
    assigned[v] = true;
    comp.add(v);
    for (final w in reverse[v] ?? const []) {
      if (!assigned[w]) dfs2(w, comp);
    }
  }

  for (final v in finishOrder.reversed) {
    if (!assigned[v]) {
      final comp = <int>[];
      dfs2(v, comp);
      sccs.add(comp);
    }
  }
  return sccs;
}

void main() {
  final graph = <int, List<int>>{
    0: [1], 1: [2], 2: [0, 3], 3: [4], 4: [5, 7], 5: [6], 6: [4], 7: [],
  };
  print(kosarajuSCC(8, graph));
}
