// Enumerate the connected components of an undirected graph.
//
// One DFS starting from each unvisited node yields exactly one
// component; the outer loop just picks up nodes DFS hasn't reached
// yet. Total work is O(V + E) — every vertex and edge is visited
// once across all DFS invocations.
//
// Alternative: Disjoint Set Union (data_structures/disjoint_set.dart)
// gives the same answer with amortized near-linear time per edge and
// lets you incrementally update as edges are added. Prefer DFS for
// a one-shot count; prefer DSU for streaming edge inputs.
//
// Complexity: O(V + E) time and space.
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
