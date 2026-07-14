// Detect a cycle in an undirected graph by processing edges through
// Union-Find. An edge whose endpoints are already in the same component
// closes a cycle.
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
