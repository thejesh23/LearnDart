// All-pairs shortest paths in O(n^3). Input is a dense matrix where
// `graph[i][j]` is the edge weight or double.infinity for absent edges.
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
