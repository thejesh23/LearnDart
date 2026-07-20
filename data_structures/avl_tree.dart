// AVL tree: the first self-balancing BST (Adelson-Velsky & Landis,
// 1962). Every node's left and right subtree heights differ by at
// most 1, guaranteeing tree height stays O(log n).
//
// After each insert (or delete), walk back up the recursion; if a
// node's balance factor goes to ±2, apply one of four rotations
// (LL, LR, RR, RL) to restore the invariant. The four cases are
// distinguished by which grandchild caused the imbalance.
//
// Contrast with red-black trees (data_structures/red_black_tree.dart):
// AVL is more strictly balanced, so lookups are marginally faster —
// good for read-heavy workloads. Red-black trees do fewer rotations
// per insert, so they win for write-heavy workloads.
//
// Complexity: O(log n) insert, contains, delete. All ops guaranteed.
class AVLNode {
  int value;
  int height = 1;
  AVLNode? left, right;
  AVLNode(this.value);
}

class AVLTree {
  AVLNode? root;

  int _h(AVLNode? n) => n?.height ?? 0;
  int _balance(AVLNode n) => _h(n.left) - _h(n.right);
  void _fix(AVLNode n) {
    n.height = 1 + (_h(n.left) > _h(n.right) ? _h(n.left) : _h(n.right));
  }

  AVLNode _rotateRight(AVLNode y) {
    final x = y.left!;
    y.left = x.right;
    x.right = y;
    _fix(y);
    _fix(x);
    return x;
  }

  AVLNode _rotateLeft(AVLNode x) {
    final y = x.right!;
    x.right = y.left;
    y.left = x;
    _fix(x);
    _fix(y);
    return y;
  }

  AVLNode _insert(AVLNode? n, int v) {
    if (n == null) return AVLNode(v);
    if (v < n.value) {
      n.left = _insert(n.left, v);
    } else if (v > n.value) {
      n.right = _insert(n.right, v);
    } else {
      return n;
    }
    _fix(n);
    final b = _balance(n);
    if (b > 1 && v < n.left!.value) return _rotateRight(n);
    if (b < -1 && v > n.right!.value) return _rotateLeft(n);
    if (b > 1 && v > n.left!.value) {
      n.left = _rotateLeft(n.left!);
      return _rotateRight(n);
    }
    if (b < -1 && v < n.right!.value) {
      n.right = _rotateRight(n.right!);
      return _rotateLeft(n);
    }
    return n;
  }

  void insert(int v) { root = _insert(root, v); }

  List<int> inOrder() {
    final out = <int>[];
    void visit(AVLNode? n) {
      if (n == null) return;
      visit(n.left);
      out.add(n.value);
      visit(n.right);
    }
    visit(root);
    return out;
  }

  int? get treeHeight => _h(root);
}

void main() {
  final t = AVLTree();
  for (final v in [30, 20, 40, 10, 25, 5]) t.insert(v);
  print(t.inOrder());     // sorted
  print('height: ${t.treeHeight}');
}
