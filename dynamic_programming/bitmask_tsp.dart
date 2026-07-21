// Bitmask DP / Held-Karp Algorithm — Exact TSP in O(2^n · n²).
// The Travelling Salesman Problem asks for the shortest Hamiltonian cycle
// visiting all n cities exactly once.  Brute force is O(n!); Held-Karp
// (1962) reduces this to O(2^n · n²) by memoising subsets.
//
// State: dp[mask][v] = minimum cost of a path that:
//   • Starts at city 0 (the depot).
//   • Visits exactly the cities in `mask` (a bitmask of {0..n-1}).
//   • Ends at city v.
//
// Transition:
//   For each unvisited city u (bit not set in mask):
//     dp[mask | (1<<u)][u] = min(dp[mask][v] + dist[v][u])
//
// Answer: min over all v of dp[(1<<n)-1][v] + dist[v][0]
// (close the tour by returning to city 0).
//
// Memory: O(2^n · n)  — for n=20 that's ~20M ints ≈ 80 MB.
// Time:   O(2^n · n²) — for n=20 that's ~400M operations.
// Practical limit: n≤20 with tight constants; n≤25 with bitwise tricks.
//
// Path reconstruction: maintain a `parent` table alongside dp.
//
// Relation to dynamic_programming/divide_conquer_dp.dart: both are
// DP optimisations of exponential search spaces; bitmask DP encodes
// subsets explicitly, while D&C DP exploits a structural property of
// the cost function.
//
// Run:  dart run dynamic_programming/bitmask_tsp.dart
import 'dart:math';

// --- Held-Karp exact TSP ----------------------------------------------

const int _INF = 1 << 30;

class TspSolver {
  final List<List<int>> dist;
  final int n;

  // dp[mask][v]: min cost of path from 0, visiting `mask`, ending at v.
  late final List<List<int>> _dp;
  late final List<List<int>> _parent;

  TspSolver(this.dist) : n = dist.length {
    final states = 1 << n;
    _dp = List.generate(states, (_) => List<int>.filled(n, _INF));
    _parent = List.generate(states, (_) => List<int>.filled(n, -1));
    _dp[1][0] = 0;  // start at city 0, only city 0 visited
  }

  int solve() {
    final full = (1 << n) - 1;

    for (int mask = 1; mask < (1 << n); mask++) {
      for (int v = 0; v < n; v++) {
        if (mask & (1 << v) == 0) continue;  // v not in mask
        if (_dp[mask][v] == _INF) continue;

        for (int u = 0; u < n; u++) {
          if (mask & (1 << u) != 0) continue;  // u already visited
          final newMask = mask | (1 << u);
          final newCost = _dp[mask][v] + dist[v][u];
          if (newCost < _dp[newMask][u]) {
            _dp[newMask][u] = newCost;
            _parent[newMask][u] = v;
          }
        }
      }
    }

    // Find the minimum cost tour.
    int best = _INF;
    for (int v = 1; v < n; v++) {
      final total = _dp[full][v] + dist[v][0];
      if (total < best) best = total;
    }
    return best;
  }

  List<int> reconstructPath() {
    final full = (1 << n) - 1;
    int best = _INF, lastCity = -1;
    for (int v = 1; v < n; v++) {
      final total = _dp[full][v] + dist[v][0];
      if (total < best) { best = total; lastCity = v; }
    }

    final path = <int>[];
    int mask = full, cur = lastCity;
    while (cur != -1) {
      path.add(cur);
      final prev = _parent[mask][cur];
      mask ^= (1 << cur);
      cur = prev;
    }
    // path is [lastCity, ..., 0]; reverse and append 0 to close the tour.
    final tour = path.reversed.toList();
    if (tour.isEmpty || tour.last != 0) tour.add(0);  // ensure city 0 closes
    return tour;
  }
}

// --- brute-force O(n!) for small n verification -----------------------

int _bruteForceTsp(List<List<int>> dist) {
  final n = dist.length;
  final cities = List<int>.generate(n - 1, (i) => i + 1);

  int best = _INF;
  void permute(List<int> arr, int start) {
    if (start == arr.length) {
      int cost = dist[0][arr[0]];
      for (int i = 0; i < arr.length - 1; i++) cost += dist[arr[i]][arr[i+1]];
      cost += dist[arr.last][0];
      if (cost < best) best = cost;
      return;
    }
    for (int i = start; i < arr.length; i++) {
      final tmp = arr[start]; arr[start] = arr[i]; arr[i] = tmp;
      permute(arr, start + 1);
      final tmp2 = arr[start]; arr[start] = arr[i]; arr[i] = tmp2;
    }
  }
  permute(cities, 0);
  return best;
}

// --- demo --------------------------------------------------------------

void main() {
  print('=== Held-Karp Exact TSP (Bitmask DP) ===\n');

  // n=5 example with a known optimal tour.
  final dist5 = [
    [ 0, 10, 15, 20,  9],
    [10,  0, 35, 25, 12],
    [15, 35,  0, 30, 20],
    [20, 25, 30,  0, 18],
    [ 9, 12, 20, 18,  0],
  ];
  final solver5 = TspSolver(dist5);
  final cost5 = solver5.solve();
  final brute5 = _bruteForceTsp(dist5);
  print('n=5, dist matrix:');
  for (final row in dist5) print('  $row');
  print('Held-Karp optimal: $cost5');
  print('Brute-force:       $brute5');
  print('Match: ${cost5 == brute5}');
  print('Optimal tour: ${solver5.reconstructPath()}\n');

  // n=8 random example with brute-force verification.
  final rng = Random(42);
  final n8 = 8;
  final dist8 = List.generate(n8, (i) => List.generate(n8, (j) =>
      i == j ? 0 : rng.nextInt(50) + 1));
  // Make symmetric.
  for (int i = 0; i < n8; i++) {
    for (int j = i + 1; j < n8; j++) {
      dist8[j][i] = dist8[i][j];
    }
  }
  final solver8 = TspSolver(dist8);
  final cost8 = solver8.solve();
  final brute8 = _bruteForceTsp(dist8);
  print('n=8, random symmetric distances (seed=42):');
  print('Held-Karp optimal: $cost8');
  print('Brute-force:       $brute8');
  print('Match: ${cost8 == brute8}');
  print('Optimal tour: ${solver8.reconstructPath()}\n');

  // n=15 timing (no brute-force verification — that would be 87 billion ops).
  final n15 = 15;
  final dist15 = List.generate(n15, (i) => List.generate(n15, (j) =>
      i == j ? 0 : rng.nextInt(100) + 1));
  for (int i = 0; i < n15; i++) {
    for (int j = i + 1; j < n15; j++) dist15[j][i] = dist15[i][j];
  }
  final sw = Stopwatch()..start();
  final solver15 = TspSolver(dist15);
  final cost15 = solver15.solve(); sw.stop();
  print('n=15 timing:');
  print('  Optimal cost: $cost15');
  print('  Time: ${sw.elapsedMilliseconds} ms');
  print('  DP states: ${1 << n15} × $n15 = ${(1 << n15) * n15} entries');
  print('  Brute-force (n=15) would need ${_factorial(14)} path evaluations (infeasible)');
}

int _factorial(int n) => n <= 1 ? 1 : n * _factorial(n - 1);
