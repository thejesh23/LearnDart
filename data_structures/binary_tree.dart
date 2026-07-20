// Binary tree — each node has at most two children — plus its three
// canonical traversals:
//   preOrder:  root, left, right   (copy the tree, prefix expressions)
//   inOrder:   left, root, right   (BST -> sorted output)
//   postOrder: left, right, root   (delete safely, postfix expressions)
//
// These aren't just curiosities — the ordering matters. In-order on
// a binary *search* tree emits values in sorted order (that's the
// entire point of a BST). Post-order deletes children before parents,
// so it's what you'd use for cleaning up resource trees. Pre-order
// serializes trees for network transmission.
//
// See data_structures/binary_search_tree.dart for BST-flavored
// insertion, and data_structures/avl_tree.dart or
// data_structures/red_black_tree.dart for self-balancing variants.

class TreeNode<T> {
  T value;
  TreeNode<T>? left;
  TreeNode<T>? right;
  TreeNode(this.value, [this.left, this.right]);
}

List<T> inOrder<T>(TreeNode<T>? root) {
  final out = <T>[];
  void visit(TreeNode<T>? n) {
    if (n == null) return;
    visit(n.left);
    out.add(n.value);
    visit(n.right);
  }
  visit(root);
  return out;
}

List<T> preOrder<T>(TreeNode<T>? root) {
  final out = <T>[];
  void visit(TreeNode<T>? n) {
    if (n == null) return;
    out.add(n.value);
    visit(n.left);
    visit(n.right);
  }
  visit(root);
  return out;
}

List<T> postOrder<T>(TreeNode<T>? root) {
  final out = <T>[];
  void visit(TreeNode<T>? n) {
    if (n == null) return;
    visit(n.left);
    visit(n.right);
    out.add(n.value);
  }
  visit(root);
  return out;
}

void main() {
  final root = TreeNode(
    1,
    TreeNode(2, TreeNode(4), TreeNode(5)),
    TreeNode(3, null, TreeNode(6)),
  );
  print('inOrder   : ${inOrder(root)}');   // [4, 2, 5, 1, 3, 6]
  print('preOrder  : ${preOrder(root)}');  // [1, 2, 4, 5, 3, 6]
  print('postOrder : ${postOrder(root)}'); // [4, 5, 2, 6, 3, 1]
}
