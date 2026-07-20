// Tarjan's strongly connected components algorithm.
//
// Definitions: a strongly connected component (SCC) is a maximal set
// of vertices where every vertex is reachable from every other.
// Tarjan finds all SCCs in a single DFS pass — an elegant improvement
// over Kosaraju's two-pass approach (graphs/kosaraju_scc.dart).
//
// The trick uses two numbers per vertex: `ids[v]` is the DFS
// discovery order; `low[v]` is the smallest id reachable from v's
// subtree by tree edges plus at most one back edge to a still-on-
// stack node. When ids[v] == low[v] at DFS return, v is the "root"
// of an SCC and everything above it on the stack (down to v) is
// popped off as one component.
//
// Complexity: O(V + E) time and space. Foundation for the "condensation
// graph" reduction — DAGs of SCCs — which underlies 2-SAT solvers
// and interconnected-dependency analyzers.
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
