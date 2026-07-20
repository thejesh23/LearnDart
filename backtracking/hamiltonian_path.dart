// Find a Hamiltonian path in a directed graph — a path that visits
// every node exactly once. This is one of Karp's original 21 NP-complete
// problems (1972); no polynomial-time algorithm is known.
//
// The backtrack tries each unvisited neighbor at each step and undoes
// the choice if the recursion can't complete the path. Trying every
// starting node covers cases where no path begins at node 0.
//
// Special case: a Hamiltonian *cycle* just needs `path[last]` to have
// an edge back to `path[0]` at the end — one extra check. The
// Traveling Salesperson Problem is the weighted-min version and is
// even harder in practice. Complexity: O(n!) worst case.
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
