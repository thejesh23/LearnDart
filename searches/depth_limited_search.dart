// Depth-limited DFS: like DFS but never descends past the given depth.
// Building block for iterative deepening search on very large graphs.
bool depthLimitedSearch<T>(
    Map<T, List<T>> graph, T start, T target, int limit) {
  bool visit(T node, int depth) {
    if (node == target) return true;
    if (depth == limit) return false;
    for (final n in graph[node] ?? const []) {
      if (visit(n, depth + 1)) return true;
    }
    return false;
  }
  return visit(start, 0);
}

void main() {
  final graph = <String, List<String>>{
    'A': ['B', 'C'],
    'B': ['D', 'E'],
    'C': ['F'],
    'D': [], 'E': ['G'], 'F': [], 'G': [],
  };
  print(depthLimitedSearch(graph, 'A', 'G', 2)); // false
  print(depthLimitedSearch(graph, 'A', 'G', 3)); // true
  print(depthLimitedSearch(graph, 'A', 'Z', 5)); // false
}
