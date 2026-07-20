// Iterative Deepening DFS (IDDFS): run depth-limited DFS at depth 0,
// then 1, then 2, ... until the target is found or the max depth is
// exceeded.
//
// Sounds wasteful — you re-explore the same shallow layers many times
// — but the analysis surprises: because a tree grows exponentially
// with depth, the *last* iteration dominates the total work. Total is
// still O(b^d) where d is the answer depth and b the branching factor,
// same as BFS.
//
// The win: IDDFS keeps DFS's O(d) memory (a single path on the stack)
// rather than BFS's O(b^d) frontier storage. Standard technique in
// game AI (alpha-beta search commonly uses iterative deepening for
// exactly this reason plus best-move ordering across iterations).
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
