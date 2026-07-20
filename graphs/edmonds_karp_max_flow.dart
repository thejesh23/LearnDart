import 'dart:collection';

// Max flow via Edmonds-Karp: BFS to find augmenting paths in the residual
// graph, repeat until no path exists. O(V * E^2).
int edmondsKarp(List<List<int>> capacity, int source, int sink) {
  final n = capacity.length;
  final residual = [for (final row in capacity) List<int>.of(row)];
  int totalFlow = 0;

  while (true) {
    final parent = List<int>.filled(n, -1);
    parent[source] = source;
    final queue = Queue<int>()..add(source);
    while (queue.isNotEmpty && parent[sink] == -1) {
      final u = queue.removeFirst();
      for (int v = 0; v < n; v++) {
        if (parent[v] == -1 && residual[u][v] > 0) {
          parent[v] = u;
          queue.add(v);
        }
      }
    }
    if (parent[sink] == -1) break;

    int pathFlow = 1 << 30;
    for (int v = sink; v != source; v = parent[v]) {
      final u = parent[v];
      if (residual[u][v] < pathFlow) pathFlow = residual[u][v];
    }
    for (int v = sink; v != source; v = parent[v]) {
      final u = parent[v];
      residual[u][v] -= pathFlow;
      residual[v][u] += pathFlow;
    }
    totalFlow += pathFlow;
  }
  return totalFlow;
}

void main() {
  final capacity = [
    [0, 16, 13, 0, 0, 0],
    [0, 0, 10, 12, 0, 0],
    [0, 4, 0, 0, 14, 0],
    [0, 0, 9, 0, 0, 20],
    [0, 0, 0, 7, 0, 4],
    [0, 0, 0, 0, 0, 0],
  ];
  print(edmondsKarp(capacity, 0, 5)); // 23
}
