// Count-Min Sketch (CMS) — estimates the frequency of any element
// in a stream using a fixed-size 2-D array of counters, regardless
// of stream length. Space is O(w * d) where w = width (counters per
// row) and d = depth (number of hash functions / rows).
//
// Problem: you want to answer "how many times has item x appeared?"
// over a billion-event click stream, without storing a counter for
// every possible item (which could be trillions of URLs).
//
// Sketch structure (Cormode & Muthukrishnan, 2005):
//   d rows, each with w counters.  d independent hash functions
//   h_1 … h_d map each element to one counter per row.
//
// Update(x):  for each row i, increment count[i][h_i(x)].
// Query(x):   return min over all rows of count[i][h_i(x)].
//
// Correctness guarantee:
//   The estimate is always ≥ the true count (no under-counting).
//   With probability ≥ 1 − δ, the estimate exceeds the true count
//   by at most ε * N, where N = total events, ε = e/w, δ = e^(−d).
//
//   Typical parameters: ε = 0.01, δ = 0.001
//     → w = ceil(e/ε) ≈ 272,  d = ceil(ln(1/δ)) ≈ 7
//     → 272 × 7 = 1904 counters ≈ 15 KB for 64-bit ints.
//
// Applications: finding heavy hitters (top-k items), DDoS source
// detection, approximate join sizes, network traffic analysis.
//
// Complement: use bloom_filter.dart (data_structures/) to check
// membership; use CMS to estimate frequency.

import 'dart:math';
import 'dart:typed_data';

// Independent hash families via pair-wise independent polynomials:
//   h(x) = (a * x + b) mod p mod w
// where p is a prime larger than the universe size.
const int _p = 0x1fffffff; // Mersenne prime 2^29 - 1

class CountMinSketch {
  final int width;   // w — counters per row
  final int depth;   // d — number of rows / hash functions
  final List<Uint32List> _table;
  final List<(int, int)> _seeds; // (a, b) pairs for each row's hash

  int totalItems = 0;

  /// [epsilon] is the max relative over-count error;
  /// [delta] is the failure probability.
  factory CountMinSketch({double epsilon = 0.01, double delta = 0.001}) {
    final w = (e / epsilon).ceil();
    final d = log(1 / delta).ceil();
    return CountMinSketch.sized(width: w, depth: d);
  }

  CountMinSketch.sized({required this.width, required this.depth})
      : _table = List.generate(depth, (_) => Uint32List(width)),
        _seeds = () {
          final rng = Random(42);
          return [
            for (int i = 0; i < depth; i++)
              (rng.nextInt(_p - 1) + 1, rng.nextInt(_p))
          ];
        }();

  int _hash(int row, int key) {
    final (a, b) = _seeds[row];
    return ((a * key + b) % _p) % width;
  }

  int _keyOf(String s) {
    // FNV-1a 32-bit — same as hyperloglog.dart
    int h = 0x811c9dc5;
    for (final c in s.codeUnits) {
      h ^= c;
      h = (h * 0x01000193) & 0xFFFFFFFF;
    }
    return h;
  }

  void add(String element, [int count = 1]) {
    totalItems += count;
    final key = _keyOf(element);
    for (int i = 0; i < depth; i++) {
      _table[i][_hash(i, key)] += count;
    }
  }

  /// Returns an upper-bound estimate of [element]'s frequency.
  int query(String element) {
    final key = _keyOf(element);
    int min = _table[0][_hash(0, key)];
    for (int i = 1; i < depth; i++) {
      final c = _table[i][_hash(i, key)];
      if (c < min) min = c;
    }
    return min;
  }

  /// True frequency we can compare against (for testing only).
  static Map<String, int> exact(List<String> stream) {
    final m = <String, int>{};
    for (final s in stream) m[s] = (m[s] ?? 0) + 1;
    return m;
  }
}

void main() {
  final rng = Random(0);
  // Build a skewed stream: items 'a'..'e' appear much more than 'f'..'z'.
  final stream = <String>[];
  for (int i = 0; i < 10000; i++) {
    // Zipf-like: 'item_0' appears ~5000 times, 'item_1' ~2500, etc.
    final rank = (log(rng.nextDouble().abs() + 1e-9) / log(0.5)).abs().toInt();
    stream.add('item_${rank.clamp(0, 99)}');
  }

  final cms  = CountMinSketch(epsilon: 0.01, delta: 0.001);
  final true_ = CountMinSketch.exact(stream);
  for (final s in stream) cms.add(s);

  print('Count-Min Sketch (w=${cms.width}, d=${cms.depth})\n');
  print('item          true   estimated   over-count');
  for (final item in ['item_0','item_1','item_2','item_3','item_5','item_10']) {
    final t = true_[item] ?? 0;
    final e = cms.query(item);
    print('  ${item.padRight(12)}  $t  ${e.toString().padLeft(9)}  +${e - t}');
  }

  // Guarantee: estimated >= true, over-count <= epsilon * N
  final maxAllowed = (0.01 * cms.totalItems).ceil();
  print('\nMax allowed over-count: $maxAllowed  (ε × N = 0.01 × ${cms.totalItems})');

  bool allOk = true;
  for (final item in true_.keys) {
    final overCount = cms.query(item) - true_[item]!;
    if (overCount > maxAllowed) { allOk = false; break; }
  }
  print('All items within guarantee: $allOk');
}
