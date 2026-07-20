// Bloom filter: a probabilistic set. `mightContain` may return true
// for elements that were never added (false positives) but never
// false for elements that *were* added (no false negatives).
//
// The trade-off: a Bloom filter with m bits and k hash functions
// storing n items has false-positive rate roughly (1 - e^(-kn/m))^k.
// Choose m and k to hit your target rate — say 10 bits per item and
// 7 hashes gives ~1% false positives.
//
// Killer app: guard-check before an expensive lookup. "Might this
// URL be in the crawled set?" — if the Bloom filter says no, save
// the disk seek. Used everywhere in databases (Cassandra, HBase,
// LevelDB use per-SSTable filters), web caches, and networking.
//
// Deletion requires a variant (counting Bloom filter). Complexity:
// O(k) time per op, O(m) space total — extremely compact.
class BloomFilter {
  final int _size;
  final int _hashes;
  final List<bool> _bits;

  BloomFilter(this._size, this._hashes) : _bits = List<bool>.filled(_size, false);

  int _hash(String key, int seed) {
    int h = seed;
    for (int i = 0; i < key.length; i++) {
      h = (h * 31 + key.codeUnitAt(i)) & 0x7FFFFFFF;
    }
    return h % _size;
  }

  void add(String key) {
    for (int i = 0; i < _hashes; i++) _bits[_hash(key, i + 1)] = true;
  }

  bool mightContain(String key) {
    for (int i = 0; i < _hashes; i++) {
      if (!_bits[_hash(key, i + 1)]) return false;
    }
    return true;
  }
}

void main() {
  final bf = BloomFilter(1024, 4);
  for (final w in ['apple', 'banana', 'cherry']) bf.add(w);
  print(bf.mightContain('apple'));      // true
  print(bf.mightContain('durian'));     // false (or rare false positive)
  print(bf.mightContain('cherry'));     // true
}
