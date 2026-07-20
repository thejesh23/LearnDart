// Bloom filter: probabilistic set with no false negatives but a tunable
// false-positive rate. Very compact — good for "have I seen this URL?"
// checks in front of an expensive lookup.
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
