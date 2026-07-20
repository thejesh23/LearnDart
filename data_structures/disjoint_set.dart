// Disjoint Set Union (DSU) — a.k.a. Union-Find. Maintains a
// partition of {0..n-1} and supports two operations:
//   find(x): which set does x belong to? (returns representative)
//   union(a, b): merge a's set with b's
//
// Two optimizations bring the amortized cost per operation to
// α(n) — the inverse Ackermann function, effectively constant for
// any n you'll ever compute:
//   - Path compression: `find` re-parents every node on the path
//     directly to the root.
//   - Union by rank: attach the shorter tree under the taller one,
//     minimizing overall height.
//
// Central to Kruskal's MST (graphs/kruskal.dart), cycle detection
// in undirected graphs (graphs/union_find_cycle_detection.dart),
// connected-component tracking as edges arrive online, Tarjan's
// off-line LCA, and equivalence-class problems everywhere.
class DisjointSet {
  final List<int> _parent;
  final List<int> _rank;

  DisjointSet(int n)
      : _parent = List<int>.generate(n, (i) => i),
        _rank = List<int>.filled(n, 0);

  int find(int x) {
    if (_parent[x] != x) _parent[x] = find(_parent[x]);
    return _parent[x];
  }

  bool union(int a, int b) {
    final ra = find(a);
    final rb = find(b);
    if (ra == rb) return false;
    if (_rank[ra] < _rank[rb]) {
      _parent[ra] = rb;
    } else if (_rank[ra] > _rank[rb]) {
      _parent[rb] = ra;
    } else {
      _parent[rb] = ra;
      _rank[ra]++;
    }
    return true;
  }

  bool connected(int a, int b) => find(a) == find(b);
}

void main() {
  final ds = DisjointSet(6);
  ds.union(0, 1);
  ds.union(2, 3);
  ds.union(1, 3);
  print(ds.connected(0, 3)); // true
  print(ds.connected(0, 5)); // false
  ds.union(4, 5);
  print(ds.connected(4, 5)); // true
}
