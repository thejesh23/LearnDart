// Depth-First Search: dive deep into one branch, backtrack when you
// hit a dead end or a visited node. Recursive form — the call stack
// implicitly plays the role BFS's queue plays. An iterative version
// swaps the queue for an explicit stack.
//
// DFS runs in O(V + E) time and O(V) space (for visited set and
// recursion). Doesn't find shortest paths in general — but the
// pre/post visit ordering encodes rich structural information used
// by topological sort (graphs/topological_sort.dart), Tarjan's SCC
// (graphs/tarjan_scc.dart), articulation-point detection
// (graphs/articulation_points.dart), and much more.
//
// Stack-overflow risk on deep graphs: convert to iterative if the
// graph diameter can be ~10^4 or more.

List<T> dfs<T>(Map<T, List<T>> graph, T start) {
  final visited = <T>{};
  final order = <T>[];
  void visit(T node) {
    if (!visited.add(node)) return;
    order.add(node);
    for (final n in graph[node] ?? const []) visit(n);
  }
  visit(start);
  return order;
}

void main() {
  final graph = <String, List<String>>{
    'A': ['B', 'C'],
    'B': ['A', 'D', 'E'],
    'C': ['A', 'F'],
    'D': ['B'],
    'E': ['B', 'F'],
    'F': ['C', 'E'],
  };
  print(dfs(graph, 'A'));
}
