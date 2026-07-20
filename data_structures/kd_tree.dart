// k-d tree (k-dimensional tree): a BST-like structure for spatial
// data. Splits alternate between dimensions — x at depth 0, y at
// depth 1, x at depth 2, and so on. Building on the sorted median
// at each level gives a balanced tree.
//
// The nearest-neighbor search is what makes it powerful: at each
// node, descend into the side of the split the target is on, then
// on the way back up check whether the *other* side's bounding
// region could hold anything closer than the current best — if
// not, prune. For low-dimensional data this gives O(log n) expected
// queries; in high dimensions (say k > 20) it degrades to O(n).
//
// This 2-D form suffices for GIS/mapping ("nearest gas station"),
// game-AI target picking, k-nearest-neighbor classification
// (machine_learning/knn_classifier.dart), and the closest-pair
// problem for large point sets.

import 'dart:math';
class _KDNode {
  final List<double> point;
  final int axis;
  _KDNode? left, right;
  _KDNode(this.point, this.axis);
}

class KDTree {
  _KDNode? _root;

  _KDNode? _build(List<List<double>> pts, int depth) {
    if (pts.isEmpty) return null;
    final axis = depth % 2;
    pts.sort((a, b) => a[axis].compareTo(b[axis]));
    final median = pts.length ~/ 2;
    final node = _KDNode(pts[median], axis)
      ..left = _build(pts.sublist(0, median), depth + 1)
      ..right = _build(pts.sublist(median + 1), depth + 1);
    return node;
  }

  KDTree.build(List<List<double>> points) {
    _root = _build([for (final p in points) List<double>.of(p)], 0);
  }

  double _dist(List<double> a, List<double> b) =>
      sqrt(pow(a[0] - b[0], 2) + pow(a[1] - b[1], 2));

  List<double> nearestNeighbor(List<double> target) {
    if (_root == null) throw StateError('empty tree');
    late List<double> best;
    double bestDist = double.infinity;
    void search(_KDNode? n) {
      if (n == null) return;
      final d = _dist(n.point, target);
      if (d < bestDist) { bestDist = d; best = n.point; }
      final diff = target[n.axis] - n.point[n.axis];
      final first = diff < 0 ? n.left : n.right;
      final second = diff < 0 ? n.right : n.left;
      search(first);
      if (diff.abs() < bestDist) search(second);
    }
    search(_root);
    return best;
  }
}

void main() {
  final tree = KDTree.build([
    [2, 3], [5, 4], [9, 6], [4, 7], [8, 1], [7, 2],
  ]);
  print(tree.nearestNeighbor([9, 2])); // [8, 1]
  print(tree.nearestNeighbor([5, 5])); // [5, 4]
}
