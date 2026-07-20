// Find a Hamiltonian path in a directed graph — a path that visits every
// node exactly once. NP-complete in general; this brute-force backtrack
// works fine for small inputs.
List<int>? hamiltonianPath(int n, Map<int, List<int>> graph) {
  final visited = List<bool>.filled(n, false);
  final path = <int>[];

  bool extend(int u) {
    visited[u] = true;
    path.add(u);
    if (path.length == n) return true;
    for (final v in graph[u] ?? const []) {
      if (!visited[v] && extend(v)) return true;
    }
    visited[u] = false;
    path.removeLast();
    return false;
  }

  for (int s = 0; s < n; s++) {
    if (extend(s)) return path;
  }
  return null;
}

void main() {
  final graph = <int, List<int>>{
    0: [1, 2, 3], 1: [0, 2], 2: [0, 1, 4], 3: [0, 4], 4: [2, 3],
  };
  print(hamiltonianPath(5, graph));
}
