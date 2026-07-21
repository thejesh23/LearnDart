// HyperLogLog (HLL) — estimates the number of *distinct* elements in
// a stream using O(m) memory where m is a small constant (typically
// 1–16 KB), regardless of how many elements the stream contains.
//
// The problem: counting exact distinct values over a billion-event
// stream would require storing up to a billion hashes. HLL trades
// exactness for space: it gives an estimate within ~2% error using
// a few kilobytes. Redis, BigQuery, Presto, and Apache Flink all
// implement HLL for `COUNT(DISTINCT ...)` at scale.
//
// Core idea (Flajolet, Fusy, Gandouet, Meunier 2007):
//   Hash each element to a uniform bit-string. The probability that
//   a hash starts with k leading zeros is 2^-(k+1). If you've seen
//   a hash with 5 leading zeros, you've *probably* seen ~2^6 = 64
//   distinct elements. The maximum leading-zero count across all
//   hashes gives a rough cardinality estimate.
//
// Reducing variance — the b-bit prefix trick:
//   Instead of one global max, partition elements into m = 2^b buckets
//   by the first b bits of their hash, and keep the max leading-zero
//   count for *remaining* bits per bucket. Average the per-bucket
//   estimates via the harmonic mean → the HyperLogLog estimator.
//
// Error: ≈ 1.04 / √m.  With m=256 buckets, error ≈ 6.5%.
//                       With m=4096 buckets, error ≈ 1.6%.
//
// This file uses a toy 32-bit FNV-1a hash so it runs without any
// crypto package. Replace with SHA-256 for production.

import 'dart:math';
import 'dart:typed_data';

// ----- FNV-1a 32-bit hash (fast, good distribution for demos) ----------

int _fnv1a32(String s) {
  int h = 0x811c9dc5;
  for (final byte in s.codeUnits) {
    h ^= byte;
    h = (h * 0x01000193) & 0xFFFFFFFF;
  }
  return h;
}

// Count leading zeros in the lower (32 - b) bits of h.
int _leadingZeros(int h, int bits) {
  if (h == 0) return bits;
  int count = 0;
  // Examine bits from the MSB of the remaining (bits)-bit window.
  for (int i = bits - 1; i >= 0; i--) {
    if ((h >> i) & 1 == 1) break;
    count++;
  }
  return count;
}

// ----- HyperLogLog -------------------------------------------------------

class HyperLogLog {
  final int b;        // bucket-index bits (b = 8 → m = 256 buckets)
  final int _m;       // number of buckets = 2^b
  final Uint8List _M; // per-bucket maximum leading-zero count
  final double _alpha;

  HyperLogLog({this.b = 8})
      : _m = 1 << b,
        _M = Uint8List(1 << b),
        _alpha = _alphaM(1 << b);

  static double _alphaM(int m) {
    // Bias-correction constant from the original paper.
    if (m == 16)   return 0.673;
    if (m == 32)   return 0.697;
    if (m == 64)   return 0.709;
    return 0.7213 / (1 + 1.079 / m); // m ≥ 128
  }

  void add(String element) {
    final hash  = _fnv1a32(element);
    final idx   = hash >>> (32 - b);          // top b bits → bucket index
    final rest  = hash & ((1 << (32 - b)) - 1); // remaining (32-b) bits
    final lz    = _leadingZeros(rest, 32 - b) + 1; // +1 per paper convention
    if (lz > _M[idx]) _M[idx] = lz;
  }

  /// Estimated distinct count.
  double count() {
    // Raw HLL estimate: α * m² * harmonic_mean(2^M[j])
    double Z = 0;
    for (int j = 0; j < _m; j++) Z += pow(2, -_M[j]);
    final raw = _alpha * _m * _m / Z;

    // Small-range correction (linear counting when many buckets are 0)
    final zeros = _M.where((x) => x == 0).length;
    if (raw <= 2.5 * _m && zeros > 0) {
      return _m * log(_m / zeros);
    }
    return raw;
  }

  void clear() => _M.fillRange(0, _m, 0);
}

void main() {
  // --- accuracy test: add n distinct strings, compare estimate ---
  for (final n in [100, 1000, 10000, 100000]) {
    final hll = HyperLogLog(b: 10); // 1024 buckets, ~1.6% error
    for (int i = 0; i < n; i++) hll.add('element_$i');
    final est = hll.count().round();
    final err = ((est - n).abs() / n * 100).toStringAsFixed(1);
    print('n=$n  estimated=$est  error=$err%');
  }

  print('');

  // --- duplicates are ignored ---
  final hll = HyperLogLog(b: 8);
  for (int i = 0; i < 1000; i++) hll.add('same_key');
  print('1000 copies of the same key → estimated distinct: ${hll.count().round()}');
  // Should be ≈ 1

  // --- merge two streams by taking per-bucket max ---
  // HLL is mergeable: union cardinality without re-processing either stream.
  final a = HyperLogLog(b: 8), b_ = HyperLogLog(b: 8);
  for (int i = 0;    i < 500; i++) a.add('item_$i');
  for (int i = 250; i < 750; i++) b_.add('item_$i');
  // Overlap 250–499 (250 shared); union should be ~750
  final merged = HyperLogLog(b: 8);
  for (int j = 0; j < 256; j++) {
    merged._M[j] = max(a._M[j], b_._M[j]);
  }
  print('union of two overlapping streams → estimated: ${merged.count().round()} (true: 750)');
}
