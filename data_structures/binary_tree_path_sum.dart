// Root-to-leaf path sum: given a binary tree and a target integer,
// does there exist a root-to-leaf path whose node values sum to
// the target?
//
// The natural formulation is recursive DFS: subtract the current
// node's value from the target and recurse into left and right.
// At a leaf (both children null), succeed iff the remainder equals
// the leaf's value.
//
// Complexity: O(n) time (each node visited once), O(h) space for
// the recursion stack, where h is the tree height. Compare with
// data_structures/binary_tree.dart and data_structures/binary_search_tree.dart
// for the tree infrastructure, and dynamic_programming/... for
// path-sum variants that permit any node→any-node paths.
// LeetCode #112.
class TreeNode {
  int value;
  TreeNode? left, right;
  TreeNode(this.value, [this.left, this.right]);
  bool get isLeaf => left == null && right == null;
}

bool hasRootToLeafPathSum(TreeNode? root, int target) {
  if (root == null) return false;
  if (root.isLeaf) return target == root.value;
  final remaining = target - root.value;
  return hasRootToLeafPathSum(root.left, remaining) ||
         hasRootToLeafPathSum(root.right, remaining);
}

void main() {
  final root = TreeNode(5,
      TreeNode(4, TreeNode(11, TreeNode(7), TreeNode(2))),
      TreeNode(8, TreeNode(13), TreeNode(4, null, TreeNode(1))));
  print(hasRootToLeafPathSum(root, 22));  // true  (5→4→11→2)
  print(hasRootToLeafPathSum(root, 26));  // true  (5→8→13)
  print(hasRootToLeafPathSum(root, 100)); // false
  print(hasRootToLeafPathSum(null, 0));   // false (empty tree has no leaves)
}
