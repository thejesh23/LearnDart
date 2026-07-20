import 'dart:collection';

// Topological sort: linear ordering of a DAG's vertices where every
// edge (u, v) has u before v in the order. Only exists when the graph
// has no cycles.
//
// Kahn's algorithm: repeatedly remove any node with in-degree 0
// (nothing depends on it). When the queue empties, either every node
// was output (success) or a cycle prevents further progress (null).
//
// Applications everywhere: build systems (compile files in dependency
// order — this is what `make` computes), spreadsheet cell evaluation,
// course-prerequisite scheduling, dependency resolution in package
// managers, event ordering in distributed systems.
//
// DFS also computes topological order (reverse post-order). Both are
// O(V + E). Complexity: O(V + E) time and space.
List<T>? topologicalSort<T>(Map<T, List<T>> graph) {
  final inDegree = <T, int>{for (final n in graph.keys) n: 0};
  for (final outs in graph.values) {
    for (final v in outs) inDegree[v] = (inDegree[v] ?? 0) + 1;
  }
  final queue = Queue<T>()
    ..addAll(inDegree.entries.where((e) => e.value == 0).map((e) => e.key));
  final order = <T>[];
  while (queue.isNotEmpty) {
    final n = queue.removeFirst();
    order.add(n);
    for (final v in graph[n] ?? const []) {
      inDegree[v] = inDegree[v]! - 1;
      if (inDegree[v] == 0) queue.add(v);
    }
  }
  return order.length == inDegree.length ? order : null;
}

void main() {
  final graph = <String, List<String>>{
    'shirt': ['tie', 'belt'],
    'tie': ['jacket'],
    'belt': ['jacket'],
    'pants': ['belt', 'shoes'],
    'socks': ['shoes'],
    'jacket': [],
    'shoes': [],
  };
  print(topologicalSort(graph));

  final cyclic = <String, List<String>>{
    'a': ['b'], 'b': ['c'], 'c': ['a'],
  };
  print(topologicalSort(cyclic)); // null
}
