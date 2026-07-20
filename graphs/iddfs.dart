// Iterative Deepening DFS: run depth-limited DFS with increasing limits.
// Combines DFS's memory efficiency with BFS's optimality on unweighted
// graphs at the cost of re-exploring shallow layers.
bool _dls<T>(Map<T, List<T>> graph, T node, T target, int depth) {
  if (node == target) return true;
  if (depth == 0) return false;
  for (final n in graph[node] ?? const []) {
    if (_dls(graph, n, target, depth - 1)) return true;
  }
  return false;
}

int? iddfs<T>(Map<T, List<T>> graph, T start, T target, {int maxDepth = 32}) {
  for (int d = 0; d <= maxDepth; d++) {
    if (_dls(graph, start, target, d)) return d;
  }
  return null;
}

void main() {
  final graph = <String, List<String>>{
    'A': ['B', 'C'],
    'B': ['D', 'E'],
    'C': ['F'],
    'D': [], 'E': ['G'], 'F': [], 'G': [],
  };
  print(iddfs(graph, 'A', 'G')); // 3
  print(iddfs(graph, 'A', 'F')); // 2
}
