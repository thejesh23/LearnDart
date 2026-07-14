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
