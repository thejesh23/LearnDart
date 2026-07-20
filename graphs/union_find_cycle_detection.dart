// Detect a cycle in an undirected graph via Union-Find (DSU).
//
// Insight: while adding edges one by one, an edge (u, v) forms a
// cycle iff u and v are already in the same connected component.
// The DSU union() call returns false in exactly that case.
//
// For undirected graphs this is the cleanest cycle test — no DFS,
// no coloring, just an amortized-near-linear pass through the edges.
// Note: for *directed* graph cycle detection, use DFS with a
// "currently on the stack" set instead (an SCC of size > 1 also
// works: see graphs/tarjan_scc.dart).
//
// Complexity: O((V + E) · α(V)) ≈ O(V + E). See
// data_structures/disjoint_set.dart for the full DSU with rank
// optimization used in Kruskal's MST.
class _DSU {
  final List<int> parent;
  _DSU(int n) : parent = List<int>.generate(n, (i) => i);
  int find(int x) {
    if (parent[x] != x) parent[x] = find(parent[x]);
    return parent[x];
  }
  bool union(int a, int b) {
    final ra = find(a), rb = find(b);
    if (ra == rb) return false;
    parent[ra] = rb;
    return true;
  }
}

bool hasCycle(int nodes, List<(int, int)> edges) {
  final dsu = _DSU(nodes);
  for (final (u, v) in edges) {
    if (!dsu.union(u, v)) return true;
  }
  return false;
}

void main() {
  print(hasCycle(4, [(0, 1), (1, 2), (2, 3)]));           // false
  print(hasCycle(4, [(0, 1), (1, 2), (2, 0), (2, 3)]));   // true
}
