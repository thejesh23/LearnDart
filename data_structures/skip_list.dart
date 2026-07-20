// Skip list: a probabilistic alternative to balanced trees. A linked
// list at the bottom, with sparse "express lane" pointer levels above
// that let you skip forward exponentially fast.
//
// Each node gets a random level (geometrically distributed, level k
// with probability p^k). Expected O(log n) search, insert, and delete
// — no rotations, no balancing bookkeeping, just coin flips.
//
// Real-world uses: Redis sorted sets (ZSET), LevelDB / RocksDB
// memtables, Java's ConcurrentSkipListMap. The lock-free variants
// scale much better than tree-based concurrent structures — a big
// reason skip lists thrive in high-concurrency environments where
// rotations would require deep locking.
//
// Complexity: expected O(log n) per operation, worst case O(n).

import 'dart:math';
class _SkipNode {
  final int value;
  final List<_SkipNode?> forward;
  _SkipNode(this.value, int level) : forward = List.filled(level + 1, null);
}

class SkipList {
  static const int _maxLevel = 16;
  static const double _p = 0.5;
  final _rng = Random();
  int _level = 0;
  final _SkipNode _header = _SkipNode(-1 << 62, _maxLevel);

  int _randomLevel() {
    int lvl = 0;
    while (lvl < _maxLevel && _rng.nextDouble() < _p) lvl++;
    return lvl;
  }

  void insert(int value) {
    final update = List<_SkipNode>.filled(_maxLevel + 1, _header);
    var cur = _header;
    for (int i = _level; i >= 0; i--) {
      while (cur.forward[i] != null && cur.forward[i]!.value < value) {
        cur = cur.forward[i]!;
      }
      update[i] = cur;
    }
    final lvl = _randomLevel();
    if (lvl > _level) _level = lvl;
    final node = _SkipNode(value, lvl);
    for (int i = 0; i <= lvl; i++) {
      node.forward[i] = update[i].forward[i];
      update[i].forward[i] = node;
    }
  }

  bool contains(int value) {
    var cur = _header;
    for (int i = _level; i >= 0; i--) {
      while (cur.forward[i] != null && cur.forward[i]!.value < value) {
        cur = cur.forward[i]!;
      }
    }
    return cur.forward[0]?.value == value;
  }

  List<int> toList() {
    final out = <int>[];
    var cur = _header.forward[0];
    while (cur != null) { out.add(cur.value); cur = cur.forward[0]; }
    return out;
  }
}

void main() {
  final s = SkipList();
  for (final v in [3, 6, 7, 9, 12, 19, 17, 26, 21, 25]) s.insert(v);
  print(s.toList());
  print(s.contains(17));
  print(s.contains(18));
}
