// Convex Hull Trick (CHT) — O(n) DP optimisation for linear cost functions.
// Named for the geometric interpretation: the lower envelope of a set of
// lines y = m·x + b forms a convex "hull" shape when viewed from below.
//
// When it applies:
//   dp[i] = min_{j<i} (a[j] · x[i] + b[j])
// where a[j] are the "slopes" and b[j] are the "intercepts" contributed
// by state j, and x[i] is the "query point" for state i.
//
// Naive: evaluate every j for every i → O(n²).
//
// CHT (monotone version):
//   Add lines in decreasing slope order.  Query in increasing x order.
//   Maintain a deque; a line is "useless" if it's never the minimum:
//   line B is useless if line A and C intersect before A and B do.
//   Adding and querying each take amortised O(1) → overall O(n).
//
// Li Chao tree: handles non-monotone slopes/queries in O(n log n).
//
// Classic applications:
//   • Optimum BST (Knuth's O(n²) reduced to O(n) with SMAWK).
//   • Divide-and-conquer on convex-cost segment splits.
//   • Shipping / trucking DP: cost to ship j units ending at station i.
//
// Relation to divide_conquer_dp.dart: D&C DP requires "opt monotonicity";
// CHT requires the "linear cost" structure.  Both achieve O(n log n)
// or O(n); use the one whose structural condition matches your problem.
//
// Run:  dart run dynamic_programming/convex_hull_trick.dart
import 'dart:math';

// --- Line and CHT data structure --------------------------------------

class Line {
  final int m;   // slope
  final int b;   // intercept

  const Line(this.m, this.b);

  int eval(int x) => m * x + b;

  @override
  String toString() => 'y = ${m}x + $b';
}

/// Returns true if [b] is never the minimum: intersection of [a] and [c]
/// is at or before intersection of [a] and [b].
bool _useless(Line a, Line b, Line c) {
  // Intersection of a and b: x = (b.b - a.b) / (a.m - b.m)
  // Intersection of a and c: x = (c.b - a.b) / (a.m - c.m)
  // b is useless iff (b.b-a.b)(a.m-c.m) >= (c.b-a.b)(a.m-b.m)
  // (integer cross-multiply to avoid division)
  return (b.b - a.b).toDouble() * (a.m - c.m) >=
         (c.b - a.b).toDouble() * (a.m - b.m);
}

/// Monotone CHT deque: lines added with decreasing slope, queried
/// with increasing x.
class ConvexHullTrick {
  final _deque = <Line>[];

  /// Add a line [l] (slope must be ≤ the last added slope).
  void addLine(Line l) {
    while (_deque.length >= 2 &&
           _useless(_deque[_deque.length - 2], _deque.last, l)) {
      _deque.removeLast();
    }
    _deque.add(l);
  }

  /// Query min value at x (x must be ≥ the last queried x).
  int query(int x) {
    while (_deque.length >= 2 &&
           _deque[0].eval(x) >= _deque[1].eval(x)) {
      _deque.removeAt(0);
    }
    return _deque[0].eval(x);
  }
}

// --- example DP: minimum cost to partition array into segments ---------
// Cost of segment [l, r] = (sum of a[l..r])².
// dp[i] = min_{j<i}(dp[j] + cost(j, i))
//       = min_{j<i}(dp[j] + (prefix[i] - prefix[j])²)
// Expanding: dp[j] + prefix[i]² - 2·prefix[i]·prefix[j] + prefix[j]²
//          = (-2·prefix[j])·prefix[i] + (dp[j] + prefix[j]²) + prefix[i]²
// Slope = -2·prefix[j], intercept = dp[j] + prefix[j]².
// The prefix[i]² term is constant per i (add after querying).

List<int> minimumPartitionCost(List<int> a) {
  final n = a.length;
  final prefix = List<int>.filled(n + 1, 0);
  for (int i = 0; i < n; i++) prefix[i + 1] = prefix[i] + a[i];

  final dp = List<int>.filled(n + 1, 1 << 60);
  dp[0] = 0;

  final cht = ConvexHullTrick();
  // Add line for j=0: slope=-2*prefix[0]=0, intercept=dp[0]+prefix[0]²=0.
  cht.addLine(Line(-2 * prefix[0], dp[0] + prefix[0] * prefix[0]));

  // Lines must be added in decreasing slope order → j in increasing order
  // gives slopes -2·prefix[0] ≥ -2·prefix[1] ≥ ... (since prefix is non-decreasing).
  // Queries are in increasing prefix[i] order. ✓

  for (int i = 1; i <= n; i++) {
    final pi = prefix[i];
    dp[i] = cht.query(pi) + pi * pi;
    cht.addLine(Line(-2 * prefix[i], dp[i] + prefix[i] * prefix[i]));
  }

  return dp;
}

/// Naïve O(n²) for verification.
List<int> minimumPartitionCostNaive(List<int> a) {
  final n = a.length;
  final prefix = List<int>.filled(n + 1, 0);
  for (int i = 0; i < n; i++) prefix[i + 1] = prefix[i] + a[i];

  final dp = List<int>.filled(n + 1, 1 << 60);
  dp[0] = 0;
  for (int i = 1; i <= n; i++) {
    for (int j = 0; j < i; j++) {
      final cost = (prefix[i] - prefix[j]) * (prefix[i] - prefix[j]);
      dp[i] = min(dp[i], dp[j] + cost);
    }
  }
  return dp;
}

// --- demo --------------------------------------------------------------

void main() {
  print('=== Convex Hull Trick — O(n) DP Optimisation ===\n');

  final a = [1, 3, 2, 5, 4, 6, 2, 1];
  print('Input array: $a');
  print('DP: minimize sum of (segment-sum)² over all partitions.\n');

  final chtResult   = minimumPartitionCost(a);
  final naiveResult = minimumPartitionCostNaive(a);

  print('CHT result   dp[]: ${chtResult.join(", ")}');
  print('Naive result dp[]: ${naiveResult.join(", ")}');
  print('Match: ${chtResult.toString() == naiveResult.toString()}\n');

  print('Optimal cost for full array: ${chtResult.last}\n');

  // Timing comparison.
  const n = 5000;
  final big = List<int>.generate(n, (i) => (i % 20) + 1);

  final sw1 = Stopwatch()..start();
  final r1 = minimumPartitionCost(big).last; sw1.stop();

  final sw2 = Stopwatch()..start();
  final r2 = minimumPartitionCostNaive(big).last; sw2.stop();

  print('Timing (n=$n):');
  print('  CHT O(n)  : ${sw1.elapsedMilliseconds} ms  → cost = $r1');
  print('  Naive O(n²): ${sw2.elapsedMilliseconds} ms → cost = $r2');
  print('  Match: ${r1 == r2}');

  // Visualise the convex envelope with a tiny example.
  print('\n--- Visualising the lower envelope ---');
  final lines = [Line(-6, 10), Line(-4, 6), Line(-2, 4), Line(0, 3)];
  final cht2 = ConvexHullTrick();
  for (final l in lines) {
    cht2.addLine(l);
    print('  Added $l');
  }
  print('  Queries (x=0..5):');
  for (int x = 0; x <= 5; x++) {
    print('    min at x=$x : ${cht2.query(x)}');
  }
}
