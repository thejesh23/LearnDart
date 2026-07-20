// Tree sort: insert every element into a binary search tree, then
// walk the tree in-order to read the elements out in sorted order.
//
// Complexity depends on the BST. With a *balanced* tree (AVL or
// red-black — see data_structures/avl_tree.dart and
// data_structures/red_black_tree.dart) it's O(n log n) worst case.
// With the plain BST used here, worst case is O(n^2) — insert already-
// sorted input and you build a linked list of right children.
//
// Rarely used as a general-purpose sort (merge/quick/tim are better)
// but it's a fine teaching example connecting sorts to trees, and
// it's the natural output of any dataset already indexed by a BST or
// std::set / TreeSet.
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
