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
