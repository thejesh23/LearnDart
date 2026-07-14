List<T> dfs<T>(Map<T, List<T>> graph, T start) {
  final visited = <T>{};
  final order = <T>[];
  void visit(T node) {
    if (!visited.add(node)) return;
    order.add(node);
    for (final n in graph[node] ?? const []) visit(n);
  }
  visit(start);
  return order;
}

void main() {
  final graph = <String, List<String>>{
    'A': ['B', 'C'],
    'B': ['A', 'D', 'E'],
    'C': ['A', 'F'],
    'D': ['B'],
    'E': ['B', 'F'],
    'F': ['C', 'E'],
  };
  print(dfs(graph, 'A'));
}
