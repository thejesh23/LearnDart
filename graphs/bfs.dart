import 'dart:collection';

List<T> bfs<T>(Map<T, List<T>> graph, T start) {
  final visited = <T>{start};
  final order = <T>[];
  final queue = Queue<T>()..add(start);
  while (queue.isNotEmpty) {
    final node = queue.removeFirst();
    order.add(node);
    for (final n in graph[node] ?? const []) {
      if (visited.add(n)) queue.add(n);
    }
  }
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
  print(bfs(graph, 'A')); // [A, B, C, D, E, F]
}
