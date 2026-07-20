// Tarjan's algorithm: strongly connected components in a directed graph
// in O(V + E) using a single DFS pass with discovery/lowlink numbers.
List<List<int>> tarjanSCC(int n, Map<int, List<int>> graph) {
  int index = 0;
  final ids = List<int>.filled(n, -1);
  final low = List<int>.filled(n, 0);
  final onStack = List<bool>.filled(n, false);
  final stack = <int>[];
  final sccs = <List<int>>[];

  void strongConnect(int v) {
    ids[v] = index;
    low[v] = index;
    index++;
    stack.add(v);
    onStack[v] = true;

    for (final w in graph[v] ?? const []) {
      if (ids[w] == -1) {
        strongConnect(w);
        if (low[w] < low[v]) low[v] = low[w];
      } else if (onStack[w] && ids[w] < low[v]) {
        low[v] = ids[w];
      }
    }

    if (low[v] == ids[v]) {
      final comp = <int>[];
      int w;
      do {
        w = stack.removeLast();
        onStack[w] = false;
        comp.add(w);
      } while (w != v);
      sccs.add(comp);
    }
  }

  for (int v = 0; v < n; v++) {
    if (ids[v] == -1) strongConnect(v);
  }
  return sccs;
}

void main() {
  final graph = <int, List<int>>{
    0: [1], 1: [2], 2: [0, 3], 3: [4], 4: [5, 7], 5: [6], 6: [4], 7: [],
  };
  print(tarjanSCC(8, graph));
}
