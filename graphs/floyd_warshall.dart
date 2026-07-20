// Floyd-Warshall: shortest paths between *every pair* of nodes.
// Three nested loops over the vertex set, with the outer loop being
// the "allowed intermediate vertex" k. After iteration k finishes,
// dist[i][j] is the shortest path from i to j using only vertices
// {0..k} as intermediates.
//
// Handles negative edge weights but not negative cycles (which will
// appear as negative diagonal entries after the algorithm runs — an
// easy post-check for detection).
//
// For sparse graphs, running Dijkstra V times is O(V · E · log V) —
// often much faster than Floyd-Warshall's cubic time. Johnson's
// algorithm combines the two for the best of both worlds.
//
// Complexity: O(V^3) time, O(V^2) space.
List<List<double>> floydWarshall(List<List<double>> graph) {
  final n = graph.length;
  final dist = [
    for (int i = 0; i < n; i++) List<double>.of(graph[i]),
  ];
  for (int k = 0; k < n; k++) {
    for (int i = 0; i < n; i++) {
      for (int j = 0; j < n; j++) {
        final via = dist[i][k] + dist[k][j];
        if (via < dist[i][j]) dist[i][j] = via;
      }
    }
  }
  return dist;
}

void main() {
  const inf = double.infinity;
  final g = <List<double>>[
    [0, 3, inf, 7],
    [8, 0, 2, inf],
    [5, inf, 0, 1],
    [2, inf, inf, 0],
  ];
  final result = floydWarshall(g);
  for (final row in result) print(row);
}
