// Disjoint Set / Union-Find with path compression and union-by-rank.
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
