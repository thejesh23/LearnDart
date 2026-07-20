// Bellman-Ford: single-source shortest paths that handles *negative*
// edge weights (unlike Dijkstra) and detects reachable negative cycles.
//
// Relax every edge V-1 times; after that pass, distances are optimal
// unless a negative cycle exists (in which case one more relaxation
// still improves something — that's the detection trick in the final
// pass).
//
// Slower than Dijkstra (O(V·E) vs O((V+E) log V)) but essential when
// weights can go negative, and used inside Johnson's all-pairs
// algorithm to reweight edges. Also the natural fit for
// currency-arbitrage detection: a negative cycle in a log-transformed
// exchange-rate graph is an arbitrage opportunity.
//
// Complexity: O(V · E) time, O(V) space.
class Edge {
  final int from, to;
  final double weight;
  const Edge(this.from, this.to, this.weight);
}

(Map<int, double> dist, bool hasNegativeCycle) bellmanFord(
    int nodes, List<Edge> edges, int start) {
  final dist = <int, double>{for (int i = 0; i < nodes; i++) i: double.infinity};
  dist[start] = 0;
  for (int i = 0; i < nodes - 1; i++) {
    for (final e in edges) {
      final du = dist[e.from]!;
      if (du != double.infinity && du + e.weight < dist[e.to]!) {
        dist[e.to] = du + e.weight;
      }
    }
  }
  for (final e in edges) {
    final du = dist[e.from]!;
    if (du != double.infinity && du + e.weight < dist[e.to]!) {
      return (dist, true);
    }
  }
  return (dist, false);
}

void main() {
  final edges = [
    Edge(0, 1, 4), Edge(0, 2, 5),
    Edge(1, 2, -3), Edge(2, 3, 4), Edge(1, 3, 6),
  ];
  print(bellmanFord(4, edges, 0)); // {0:0, 1:4, 2:1, 3:5}
}
