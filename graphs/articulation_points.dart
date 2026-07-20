// Articulation points (cut vertices) of an undirected graph — nodes whose
// removal increases the number of connected components. Tarjan's method
// with discovery times and lowlink values, single DFS.
Set<int> articulationPoints(int n, Map<int, List<int>> graph) {
  int timer = 0;
  final disc = List<int>.filled(n, -1);
  final low = List<int>.filled(n, 0);
  final result = <int>{};

  void dfs(int u, int parent) {
    disc[u] = low[u] = timer++;
    int children = 0;
    for (final v in graph[u] ?? const []) {
      if (disc[v] == -1) {
        children++;
        dfs(v, u);
        if (low[v] < low[u]) low[u] = low[v];
        if (parent == -1 && children > 1) result.add(u);
        if (parent != -1 && low[v] >= disc[u]) result.add(u);
      } else if (v != parent && disc[v] < low[u]) {
        low[u] = disc[v];
      }
    }
  }

  for (int v = 0; v < n; v++) {
    if (disc[v] == -1) dfs(v, -1);
  }
  return result;
}

void main() {
  final graph = <int, List<int>>{
    0: [1, 2], 1: [0, 2], 2: [0, 1, 3], 3: [2, 4], 4: [3],
  };
  print(articulationPoints(5, graph)); // {2, 3}
}
