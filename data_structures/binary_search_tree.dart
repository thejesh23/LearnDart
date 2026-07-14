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
