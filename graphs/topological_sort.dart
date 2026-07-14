import 'dart:collection';

// Kahn's algorithm: repeatedly remove nodes with zero in-degree.
// Returns null if the graph has a cycle.
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
