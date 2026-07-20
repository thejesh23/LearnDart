// Articulation points (cut vertices): nodes whose removal disconnects
// the graph. Together with bridges (cut edges), they identify the
// "weak spots" in a network.
//
// Tarjan's single-DFS approach with discovery times (disc) and
// lowlink values (low). Two cases identify a cut vertex u:
//   1. u is a DFS root with more than one child in the DFS tree.
//   2. u has a child v such that no vertex in v's subtree can reach
//      an ancestor of u (low[v] >= disc[u]).
//
// Used in network reliability analysis (which routers cause the most
// damage if they go down?), and in social-network analysis to find
// "brokers" between communities.
//
// Complexity: O(V + E) time and space.
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
