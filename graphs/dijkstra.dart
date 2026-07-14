import 'dart:collection';

// Shortest paths from `start` to every reachable node in a graph with
// non-negative edge weights. Uses a sorted set as a min-priority queue for
// clarity — swap in a proper heap for very large graphs.
Map<T, double> dijkstra<T>(Map<T, List<(T, double)>> graph, T start) {
  final dist = <T, double>{start: 0};
  final visited = <T>{};
  final pq = SplayTreeSet<(double, T)>((a, b) {
    final c = a.$1.compareTo(b.$1);
    return c != 0 ? c : a.$2.hashCode.compareTo(b.$2.hashCode);
  })
    ..add((0, start));

  while (pq.isNotEmpty) {
    final entry = pq.first;
    pq.remove(entry);
    final (d, node) = entry;
    if (!visited.add(node)) continue;

    for (final (neighbor, weight) in graph[node] ?? const []) {
      final nd = d + weight;
      if (nd < (dist[neighbor] ?? double.infinity)) {
        dist[neighbor] = nd;
        pq.add((nd, neighbor));
      }
    }
  }
  return dist;
}

void main() {
  final graph = <String, List<(String, double)>>{
    'A': [('B', 1), ('C', 4)],
    'B': [('C', 2), ('D', 5)],
    'C': [('D', 1)],
    'D': [],
  };
  print(dijkstra(graph, 'A')); // {A: 0, B: 1, C: 3, D: 4}
}
