// Left-leaning red-black tree (LLRB), Sedgewick's simplified 2008
// variant of the classic red-black tree. Every node is red or black;
// the color invariants keep the tree height at most 2·log₂(n+1).
//
// The invariants:
//   1. Root is black.
//   2. Red edges never lean right — a red child must be a left child.
//   3. No two red nodes are consecutive (no red-red parent-child).
//   4. Every root-to-leaf path has the same number of black nodes.
//
// After each insertion, three fix-up steps (in this order) restore
// the invariants: rotate-left if right-red-not-left-red, rotate-right
// if left-red and left-left-red, flip colors if both children red.
//
// Real-world uses: java.util.TreeMap, C++ std::map, Linux kernel
// scheduler CFS, Emacs' interval trees. See
// data_structures/avl_tree.dart for a more strictly-balanced (and
// more rotation-heavy) alternative.
enum _Color { red, black }

class _RBNode {
  int value;
  _Color color;
  _RBNode? left, right;
  _RBNode(this.value, this.color);
}

class RedBlackTree {
  _RBNode? _root;

  bool _isRed(_RBNode? n) => n?.color == _Color.red;

  _RBNode _rotateLeft(_RBNode h) {
    final x = h.right!;
    h.right = x.left;
    x.left = h;
    x.color = h.color;
    h.color = _Color.red;
    return x;
  }

  _RBNode _rotateRight(_RBNode h) {
    final x = h.left!;
    h.left = x.right;
    x.right = h;
    x.color = h.color;
    h.color = _Color.red;
    return x;
  }

  void _flipColors(_RBNode h) {
    h.color = _Color.red;
    h.left!.color = _Color.black;
    h.right!.color = _Color.black;
  }

  _RBNode _insert(_RBNode? h, int v) {
    if (h == null) return _RBNode(v, _Color.red);
    if (v < h.value) {
      h.left = _insert(h.left, v);
    } else if (v > h.value) {
      h.right = _insert(h.right, v);
    }
    if (_isRed(h.right) && !_isRed(h.left)) h = _rotateLeft(h);
    if (_isRed(h.left) && _isRed(h.left!.left)) h = _rotateRight(h);
    if (_isRed(h.left) && _isRed(h.right)) _flipColors(h);
    return h;
  }

  void insert(int v) {
    _root = _insert(_root, v);
    _root!.color = _Color.black;
  }

  List<int> inOrder() {
    final out = <int>[];
    void walk(_RBNode? n) {
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
  final t = RedBlackTree();
  for (final v in [10, 20, 5, 15, 25, 3, 8, 30, 1]) t.insert(v);
  print(t.inOrder());
}
