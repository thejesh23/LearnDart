// Divide-and-Conquer DP Optimisation — O(n²k) → O(nk log n).
// Discovered independently by Knuth (1971, for optimal BST) and
// generalised by Yao (1980) and later identified as a pattern by
// competitive programmers.
//
// When it applies:
//   dp[i][j] = min_{k<j} (dp[i-1][k] + cost(k, j))
// and the cost function satisfies the "opt monotonicity" property:
//   opt(i, j) ≤ opt(i, j+1)    for all valid i, j
// where opt(i,j) is the optimal split point for state (i,j).
//
// Key insight: if we compute dp[i][mid] first, we know:
//   opt(i, left half) ∈ [opt_lo, opt(i, mid)]
//   opt(i, right half) ∈ [opt(i, mid), opt_hi]
// Each layer of the DP can be computed in O(n log n) via binary
// recursion on mid, giving O(nk log n) total for k layers.
//
// When does opt monotonicity hold?
//   A sufficient condition is "concave SMAWK": cost satisfies the
//   quadrangle inequality cost(a,c) + cost(b,d) ≤ cost(a,d) + cost(b,c)
//   for a ≤ b ≤ c ≤ d.
//
// Applications: K-median clustering, optimal file merging, matrix chain
// multiplication, print justification (TeX line-breaking algorithm).
//
// Relation to convex_hull_trick.dart: CHT requires linear cost structure;
// D&C DP requires opt-monotonicity (weaker but different condition).
// Both improve O(n²) transitions to sub-quadratic.
//
// Run:  dart run dynamic_programming/divide_conquer_dp.dart
import 'dart:math';

// --- cost function: segment max (satisfies quadrangle inequality) -----

/// cost(l, r) = maximum of a[l..r-1].
/// We use a sparse table for O(1) range max queries.
class RangeMax {
  late final List<List<int>> _table;
  final List<int> _a;

  RangeMax(this._a) {
    final n = _a.length;
    final k = (log(n) / ln2).floor() + 1;
    _table = List.generate(k, (_) => List<int>.filled(n, 0));
    _table[0] = List<int>.from(_a);
    for (int j = 1; j < k; j++) {
      for (int i = 0; i + (1 << j) <= n; i++) {
        _table[j][i] = max(_table[j - 1][i], _table[j - 1][i + (1 << (j - 1))]);
      }
    }
  }

  int query(int l, int r) {
    if (l >= r) return 0;
    final k = (log(r - l) / ln2).floor();
    return max(_table[k][l], _table[k][r - (1 << k)]);
  }
}

// --- divide-and-conquer DP layer computation --------------------------

/// Compute one layer of D&C DP.
/// [prev] = dp[i-1][0..n].  Returns dp[i][0..n].
List<int> _dcLayer(List<int> prev, int Function(int l, int r) cost) {
  final n = prev.length - 1;
  final dp = List<int>.filled(n + 1, 1 << 60);

  void solve(int lo, int hi, int optLo, int optHi) {
    if (lo > hi) return;
    final mid = (lo + hi) ~/ 2;
    int best = 1 << 60;
    int bestK = optLo;
    for (int k = optLo; k <= min(mid - 1, optHi); k++) {
      final val = prev[k] + cost(k, mid);
      if (val < best) { best = val; bestK = k; }
    }
    dp[mid] = best;
    solve(lo, mid - 1, optLo, bestK);
    solve(mid + 1, hi, bestK, optHi);
  }

  solve(1, n, 0, n - 1);
  return dp;
}

/// Full D&C DP over [layers] rounds.
/// dp[0][0] = 0; dp[0][j] = cost(0,j).
/// dp[i][j] = min_{k<j}(dp[i-1][k] + cost(k,j)).
List<List<int>> divideConquerDP(int layers, int n, int Function(int, int) cost) {
  final result = List<List<int>>.generate(layers + 1, (_) => List<int>.filled(n + 1, 1 << 60));
  result[0][0] = 0;
  for (int j = 1; j <= n; j++) result[0][j] = cost(0, j);

  for (int i = 1; i <= layers; i++) {
    result[i] = _dcLayer(result[i - 1], cost);
    result[i][0] = 1 << 60;  // 0-length partition is invalid
  }
  return result;
}

// --- brute-force O(n²k) for verification ------------------------------

List<List<int>> bruteForceDP(int layers, int n, int Function(int, int) cost) {
  final dp = List.generate(layers + 1, (_) => List<int>.filled(n + 1, 1 << 60));
  dp[0][0] = 0;
  for (int j = 1; j <= n; j++) dp[0][j] = cost(0, j);

  for (int i = 1; i <= layers; i++) {
    for (int j = 1; j <= n; j++) {
      for (int k = 0; k < j; k++) {
        if (dp[i - 1][k] == 1 << 60) continue;
        final val = dp[i - 1][k] + cost(k, j);
        if (val < dp[i][j]) dp[i][j] = val;
      }
    }
  }
  return dp;
}

// --- demo --------------------------------------------------------------

void main() {
  print('=== Divide-and-Conquer DP Optimisation ===\n');

  // Partition a = [3, 1, 4, 1, 5, 9, 2, 6] into 3 segments,
  // minimising sum of segment-maxima.
  final a = [3, 1, 4, 1, 5, 9, 2, 6];
  final n = a.length;
  final k = 3;  // number of segments

  final rm = RangeMax(a);
  int cost(int l, int r) => rm.query(l, r);  // max of a[l..r-1]

  print('Array  : $a  (n=$n, k=$k segments)');
  print('Cost(l,r) = max of a[l..r-1]\n');

  final dcResult    = divideConquerDP(k - 1, n, cost);
  final bruteResult = bruteForceDP(k - 1, n, cost);

  // The final answer is dp[k-1][n].
  final dcAns    = dcResult[k - 1][n];
  final bruteAns = bruteResult[k - 1][n];

  print('D&C DP answer   : $dcAns');
  print('Brute-force answer: $bruteAns');
  print('Match           : ${dcAns == bruteAns}\n');

  // DP table.
  print('DP table (rows = layers 0..${k-1}, cols = n):');
  for (int i = 0; i < k; i++) {
    final row = dcResult[i].map((v) => v == 1 << 60 ? ' ∞' : v.toString().padLeft(2)).join(', ');
    print('  layer $i: [$row]');
  }

  // Timing comparison.
  final bigN = 500;
  final bigK = 10;
  final bigA = List<int>.generate(bigN, (i) => (i * 7 + 3) % 100 + 1);
  final bigRm = RangeMax(bigA);
  int bigCost(int l, int r) => bigRm.query(l, r);

  final sw1 = Stopwatch()..start();
  final r1 = divideConquerDP(bigK - 1, bigN, bigCost)[bigK - 1][bigN];
  sw1.stop();

  final sw2 = Stopwatch()..start();
  final r2 = bruteForceDP(bigK - 1, bigN, bigCost)[bigK - 1][bigN];
  sw2.stop();

  print('\nTiming (n=$bigN, k=$bigK):');
  print('  D&C DP O(nk log n): ${sw1.elapsedMilliseconds} ms  → $r1');
  print('  Brute O(n²k)      : ${sw2.elapsedMilliseconds} ms  → $r2');
  print('  Match             : ${r1 == r2}');
}
