// Kruskal's algorithm: build a minimum spanning tree by considering
// edges in increasing order of weight and accepting each edge that
// doesn't complete a cycle with previously-accepted edges.
//
// The cycle check needs to test "are u and v already in the same
// connected component?" — the exact query a Disjoint Set Union (DSU)
// / Union-Find data structure answers in near-constant amortized time.
// See data_structures/disjoint_set.dart for a standalone DSU.
//
// Cleaner than Prim in code and reasoning; often faster on sparse
// graphs. Both are optimal MST algorithms — the choice is about
// engineering constants.
//
// Complexity: O(E log E) time (dominated by the sort), O(V + E) space.
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
