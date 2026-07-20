// Treap = tree + heap. Each node stores a value (BST-ordered) and a
// random priority (heap-ordered). The two orderings together
// uniquely determine the tree structure.
//
// Because priorities are random, the resulting BST is
// probabilistically balanced — expected O(log n) height. Insertions
// rotate on the way back up to restore the heap property whenever a
// child ends up with higher priority than its parent.
//
// Much simpler code than AVL or red-black (no color logic, no
// balance-factor arithmetic — just rotations conditional on
// priority). See data_structures/avl_tree.dart and
// data_structures/red_black_tree.dart for the deterministic
// alternatives.
//
// Complexity: expected O(log n) per operation, worst case O(n).

import 'dart:math';
class _TreapNode {
  int value;
  int priority;
  _TreapNode? left, right;
  _TreapNode(this.value, this.priority);
}

class Treap {
  _TreapNode? _root;
  final _rng = Random();

  _TreapNode _rotateRight(_TreapNode n) {
    final l = n.left!;
    n.left = l.right;
    l.right = n;
    return l;
  }

  _TreapNode _rotateLeft(_TreapNode n) {
    final r = n.right!;
    n.right = r.left;
    r.left = n;
    return r;
  }

  _TreapNode _insert(_TreapNode? n, int v) {
    if (n == null) return _TreapNode(v, _rng.nextInt(1 << 30));
    if (v < n.value) {
      n.left = _insert(n.left, v);
      if (n.left!.priority > n.priority) n = _rotateRight(n);
    } else if (v > n.value) {
      n.right = _insert(n.right, v);
      if (n.right!.priority > n.priority) n = _rotateLeft(n);
    }
    return n;
  }

  void insert(int v) { _root = _insert(_root, v); }

  bool contains(int v) {
    var cur = _root;
    while (cur != null) {
      if (v == cur.value) return true;
      cur = v < cur.value ? cur.left : cur.right;
    }
    return false;
  }

  List<int> inOrder() {
    final out = <int>[];
    void walk(_TreapNode? n) {
      if (n == null) return;
      walk(n.left);
      out.add(n.value);
      walk(n.right);
    }
    walk(_root);
    return out;
  }
}

void main() {
  final t = Treap();
  for (final v in [5, 3, 8, 1, 9, 2, 7]) t.insert(v);
  print(t.inOrder());
  print(t.contains(8));
  print(t.contains(4));
}
