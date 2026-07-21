// B-tree — the index structure underlying virtually every relational
// database and file system (SQLite, InnoDB, PostgreSQL, NTFS, HFS+).
// A generalisation of BST where each node holds t–1 to 2t–1 sorted
// keys and correspondingly 0 or t to 2t children. The higher fan-out
// keeps tree height logarithmically small in base t, which matters
// when each node access is a disk read (t tuned to page size).
//
// Invariants (minimum degree t, this file uses t = 3):
//   • Every node except the root holds ≥ t–1 and ≤ 2t–1 keys.
//   • The root holds 1 to 2t–1 keys.
//   • A node with k keys has exactly k+1 children (if non-leaf).
//   • All leaves are at the same depth.
//   • Keys within each node are sorted ascending.
//   • Keys in child[i] are all < key[i] and > key[i-1].
//
// Insert strategy — "proactive split" (single downward pass):
//   Whenever a full node (2t–1 keys) is encountered on the way down,
//   split it before descending. This guarantees a non-full parent is
//   always available to absorb the promoted median — no backtracking.
//
// Height: ≤ log_t((n+1)/2), so at t=500 a tree with a billion keys
// has height ≤ 4. Three disk reads finds any record.
//
// Complexity: search O(t log_t n), insert O(t log_t n) amortised.

class _BNode {
  final List<int> keys = [];
  final List<_BNode> children = [];
  bool isLeaf = true;
}

class BTree {
  final int t;  // minimum degree
  late _BNode _root;

  BTree(this.t) : assert(t >= 2, 'minimum degree must be ≥ 2') {
    _root = _BNode();
  }

  bool search(int k) => _search(_root, k);

  bool _search(_BNode x, int k) {
    int i = 0;
    while (i < x.keys.length && k > x.keys[i]) i++;
    if (i < x.keys.length && k == x.keys[i]) return true;
    if (x.isLeaf) return false;
    return _search(x.children[i], k);
  }

  void insert(int k) {
    final r = _root;
    if (r.keys.length == 2 * t - 1) {
      // Root is full: create a new root, old root becomes left child.
      final s = _BNode()..isLeaf = false;
      _root = s;
      s.children.add(r);
      _splitChild(s, 0);
      _insertNonFull(s, k);
    } else {
      _insertNonFull(r, k);
    }
  }

  // Pre-condition: x is not full.
  void _insertNonFull(_BNode x, int k) {
    int i = x.keys.length - 1;
    if (x.isLeaf) {
      while (i >= 0 && k < x.keys[i]) i--;
      x.keys.insert(i + 1, k);
    } else {
      while (i >= 0 && k < x.keys[i]) i--;
      i++;
      if (x.children[i].keys.length == 2 * t - 1) {
        _splitChild(x, i);
        if (k > x.keys[i]) i++;  // k now belongs to the new right half
      }
      _insertNonFull(x.children[i], k);
    }
  }

  // Split x.children[i] (which must be full) around its median.
  // The median key rises to x.keys[i]; the upper half of the child
  // becomes a new sibling at x.children[i+1].
  void _splitChild(_BNode x, int i) {
    final y = x.children[i];     // full child (2t–1 keys)
    final z = _BNode()..isLeaf = y.isLeaf;

    // z gets the upper t–1 keys of y
    z.keys.addAll(y.keys.sublist(t));
    if (!y.isLeaf) z.children.addAll(y.children.sublist(t));

    // median key rises to parent
    final median = y.keys[t - 1];
    y.keys.removeRange(t - 1, y.keys.length);
    if (!y.isLeaf) y.children.removeRange(t, y.children.length);

    x.keys.insert(i, median);
    x.children.insert(i + 1, z);
  }

  // Returns a breadth-first list of levels for pretty printing.
  List<List<List<int>>> levels() {
    final result = <List<List<int>>>[];
    var current = [_root];
    while (current.isNotEmpty) {
      result.add(current.map((n) => List<int>.from(n.keys)).toList());
      final next = <_BNode>[];
      for (final n in current) next.addAll(n.children);
      current = next;
    }
    return result;
  }
}

void main() {
  final t = BTree(3);  // nodes hold 2–5 keys, 3–6 children

  final keys = [10, 20, 5, 6, 12, 30, 7, 17, 3, 25, 4, 15, 8];
  for (final k in keys) t.insert(k);

  print('B-tree (t=3) after inserting $keys');
  final lvls = t.levels();
  for (int i = 0; i < lvls.length; i++) {
    print('  Level $i: ${lvls[i]}');
  }

  final checks = [6, 15, 99, 3, 25];
  print('');
  for (final k in checks) {
    print('  search($k) → ${t.search(k)}');
  }
  // All inserted keys found; 99 not found.
}
