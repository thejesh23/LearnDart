// Binary Search Tree: a binary tree where every node's left subtree
// contains only smaller values and every right subtree contains only
// larger values. In-order traversal produces the values in sorted
// order.
//
// Insert, contains, and delete are O(h) — where h is the tree height.
// If insertions come in random order, h is O(log n) on average. But
// inserting already-sorted data (a common accidental case) degrades
// to a linked list with h = O(n). Self-balancing variants (AVL, red-
// black, treap) fix this by rotating during insert/delete to keep
// h = O(log n) worst case.
//
// See data_structures/avl_tree.dart,
// data_structures/red_black_tree.dart, and data_structures/treap.dart
// for the guaranteed-balanced variants.

class BSTNode {
  int value;
  BSTNode? left;
  BSTNode? right;
  BSTNode(this.value);
}

class BinarySearchTree {
  BSTNode? root;

  void insert(int v) => root = _insert(root, v);
  BSTNode _insert(BSTNode? n, int v) {
    if (n == null) return BSTNode(v);
    if (v < n.value) {
      n.left = _insert(n.left, v);
    } else if (v > n.value) {
      n.right = _insert(n.right, v);
    }
    return n;
  }

  bool contains(int v) {
    var cur = root;
    while (cur != null) {
      if (v == cur.value) return true;
      cur = v < cur.value ? cur.left : cur.right;
    }
    return false;
  }

  List<int> inOrder() {
    final out = <int>[];
    void visit(BSTNode? n) {
      if (n == null) return;
      visit(n.left);
      out.add(n.value);
      visit(n.right);
    }
    visit(root);
    return out;
  }
}

void main() {
  final bst = BinarySearchTree();
  for (final v in [5, 2, 7, 1, 3, 6, 8]) {
    bst.insert(v);
  }
  print(bst.inOrder());       // [1, 2, 3, 5, 6, 7, 8]
  print(bst.contains(6));     // true
  print(bst.contains(4));     // false
}
