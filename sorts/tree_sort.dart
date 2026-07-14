// Tree sort: build a BST and read it back in-order.
class _Node {
  int value;
  _Node? left, right;
  _Node(this.value);
}

class _BST {
  _Node? root;
  void insert(int v) { root = _insert(root, v); }
  _Node _insert(_Node? n, int v) {
    if (n == null) return _Node(v);
    if (v < n.value) {
      n.left = _insert(n.left, v);
    } else {
      n.right = _insert(n.right, v);
    }
    return n;
  }
  void inOrder(_Node? n, List<int> out) {
    if (n == null) return;
    inOrder(n.left, out);
    out.add(n.value);
    inOrder(n.right, out);
  }
}

List<int> treeSort(List<int> input) {
  final bst = _BST();
  for (final v in input) bst.insert(v);
  final out = <int>[];
  bst.inOrder(bst.root, out);
  return out;
}

void main() {
  print(treeSort([5, 2, 9, 1, 7, 3, 5]));
}
