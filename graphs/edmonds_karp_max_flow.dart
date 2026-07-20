import 'dart:collection';

// Edmonds-Karp max flow: an implementation of the Ford-Fulkerson
// algorithm that specifically uses BFS to find augmenting paths.
//
// Each iteration: BFS through the residual graph (edges still with
// remaining capacity plus reverse edges from previous flow) to find
// a source-to-sink path; push the bottleneck capacity through it;
// repeat until no augmenting path exists. Max-flow min-cut theorem
// guarantees the total pushed equals the minimum s-t cut.
//
// Using BFS (vs Ford-Fulkerson's unspecified path choice) is what
// bounds Edmonds-Karp at O(V·E²) rather than pseudo-polynomial.
// Modern max-flow algorithms — Dinic's, Push-Relabel — are faster:
// O(V²E) and O(V²√E) respectively.
//
// Applications: bipartite matching, image segmentation, project
// selection, network routing capacity planning.
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
