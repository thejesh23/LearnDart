// Enumerate the connected components of an undirected graph via DFS.
List<List<T>> connectedComponents<T>(Map<T, List<T>> graph) {
  final visited = <T>{};
  final components = <List<T>>[];

  void dfs(T node, List<T> comp) {
    if (!visited.add(node)) return;
    comp.add(node);
    for (final n in graph[node] ?? const []) dfs(n, comp);
  }

  for (final start in graph.keys) {
    if (visited.contains(start)) continue;
    final comp = <T>[];
    dfs(start, comp);
    components.add(comp);
  }
  return components;
}

void main() {
  final graph = <String, List<String>>{
    'A': ['B'], 'B': ['A'],
    'C': ['D', 'E'], 'D': ['C'], 'E': ['C'],
    'F': [],
  };
  for (final c in connectedComponents(graph)) print(c);
}
