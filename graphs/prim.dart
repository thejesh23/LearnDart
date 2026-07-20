import 'dart:collection';

// Prim's algorithm: build a minimum spanning tree by *growing* a
// single tree from a start vertex. At each step, pick the cheapest
// edge leading from a tree vertex to a non-tree vertex.
//
// Similar shape to Dijkstra — same priority queue skeleton, different
// key stored. Prim minimizes edge weight from the tree; Dijkstra
// minimizes cumulative path distance from the source.
//
// Complexity: O((V + E) log V) with a binary heap. Contrast with
// Kruskal (graphs/kruskal.dart), which sorts all edges up front and
// uses Union-Find. Prim wins on dense graphs (fewer edges to consider
// per step); Kruskal on sparse graphs (linear-time Union-Find beats
// heap operations).
List<(int, int, double)> primMST(int n, Map<int, List<(int, double)>> graph) {
  final inTree = List<bool>.filled(n, false);
  final mst = <(int, int, double)>[];
  final pq = SplayTreeSet<(double, int, int)>((a, b) {
    final c = a.$1.compareTo(b.$1);
    if (c != 0) return c;
    final d = a.$2.compareTo(b.$2);
    return d != 0 ? d : a.$3.compareTo(b.$3);
  });

  void addEdges(int u) {
    inTree[u] = true;
    for (final (v, w) in graph[u] ?? const []) {
      if (!inTree[v]) pq.add((w, u, v));
    }
  }

  addEdges(0);
  while (pq.isNotEmpty && mst.length < n - 1) {
    final (w, u, v) = pq.first;
    pq.remove(pq.first);
    if (inTree[v]) continue;
    mst.add((u, v, w));
    addEdges(v);
  }
  return mst;
}

void main() {
  final g = <int, List<(int, double)>>{
    0: [(1, 2), (3, 6)],
    1: [(0, 2), (2, 3), (3, 8), (4, 5)],
    2: [(1, 3), (4, 7)],
    3: [(0, 6), (1, 8)],
    4: [(1, 5), (2, 7)],
  };
  print(primMST(5, g));
}
