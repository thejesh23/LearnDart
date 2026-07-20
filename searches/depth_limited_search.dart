// Depth-limited DFS: standard depth-first search but never recurses
// past `limit` levels below the start. Below the limit, we treat every
// node as a leaf even if it has children.
//
// The building block for iterative deepening (graphs/iddfs.dart), which
// gets BFS's optimality on unweighted graphs with DFS's O(depth) memory
// footprint by running depth-limited searches at increasing depths.
//
// Returning false doesn't mean the target is unreachable — only that
// it isn't within `limit` moves. Distinguish "not found within budget"
// from "genuinely unreachable" by comparing against the graph's
// diameter or an upper bound you can pre-compute.
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
