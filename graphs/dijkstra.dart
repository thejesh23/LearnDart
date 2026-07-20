import 'dart:collection';

// Dijkstra's algorithm: single-source shortest paths in a graph with
// *non-negative* edge weights. Grow a set of "settled" nodes one at
// a time, always picking the frontier node with the smallest tentative
// distance.
//
// The correctness depends on non-negativity: the moment you pull a
// node from the priority queue, no unseen path can beat its recorded
// distance (any such path would have to go through a node with even
// smaller distance, which would have been settled first). Negative
// weights break this invariant — use Bellman-Ford instead
// (graphs/bellman_ford.dart).
//
// Complexity: O((V + E) log V) with a binary heap or sorted set. For
// dense graphs an O(V^2) array-of-distances form can win. See
// graphs/a_star.dart for the heuristic-guided variant.
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
