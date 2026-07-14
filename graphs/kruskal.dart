// Minimum spanning tree via Kruskal's algorithm: sort edges by weight and
// add each one that doesn't create a cycle (checked with Union-Find).
class _DSU {
  final List<int> parent;
  final List<int> rank_;
  _DSU(int n)
      : parent = List<int>.generate(n, (i) => i),
        rank_ = List<int>.filled(n, 0);
  int find(int x) {
    if (parent[x] != x) parent[x] = find(parent[x]);
    return parent[x];
  }
  bool union(int a, int b) {
    final ra = find(a), rb = find(b);
    if (ra == rb) return false;
    if (rank_[ra] < rank_[rb]) {
      parent[ra] = rb;
    } else if (rank_[ra] > rank_[rb]) {
      parent[rb] = ra;
    } else {
      parent[rb] = ra;
      rank_[ra]++;
    }
    return true;
  }
}

List<(int, int, double)> kruskalMST(
    int n, List<(int, int, double)> edges) {
  final sorted = List<(int, int, double)>.of(edges)
    ..sort((a, b) => a.$3.compareTo(b.$3));
  final dsu = _DSU(n);
  final mst = <(int, int, double)>[];
  for (final (u, v, w) in sorted) {
    if (dsu.union(u, v)) mst.add((u, v, w));
    if (mst.length == n - 1) break;
  }
  return mst;
}

void main() {
  final edges = <(int, int, double)>[
    (0, 1, 2), (0, 3, 6), (1, 2, 3), (1, 3, 8),
    (1, 4, 5), (2, 4, 7),
  ];
  print(kruskalMST(5, edges));
}
