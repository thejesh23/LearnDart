// Undirected graph represented as an adjacency list: for each node,
// a set of the nodes it connects to.
//
// The two standard graph representations:
//   - Adjacency list (this file): O(V + E) space, iterating over a
//     vertex's neighbors is O(deg(v)). Best for sparse graphs.
//   - Adjacency matrix: O(V²) space, O(1) edge existence check,
//     O(V) neighbor iteration. Best for dense graphs or when many
//     "is there an edge?" queries are needed.
//
// This uses Set<T> instead of List<T> for each adjacency list, which
// makes duplicate edges idempotent and edge lookup O(1). All the
// graph algorithms in graphs/ operate on Map<T, ...> representations
// like this one, or their weighted variants.

class Graph<T> {
  final Map<T, Set<T>> _adj = {};

  void addNode(T node) => _adj.putIfAbsent(node, () => <T>{});

  void addEdge(T a, T b, {bool undirected = true}) {
    addNode(a);
    addNode(b);
    _adj[a]!.add(b);
    if (undirected) _adj[b]!.add(a);
  }

  Iterable<T> neighbors(T node) => _adj[node] ?? const {};

  Iterable<T> get nodes => _adj.keys;

  @override
  String toString() {
    final sb = StringBuffer();
    for (final n in _adj.keys) {
      sb.writeln('$n -> ${_adj[n]}');
    }
    return sb.toString().trimRight();
  }
}

void main() {
  final g = Graph<String>();
  g.addEdge('A', 'B');
  g.addEdge('A', 'C');
  g.addEdge('B', 'D');
  g.addEdge('C', 'D');
  print(g);
  print("neighbors of A: ${g.neighbors('A').toList()}");
}
