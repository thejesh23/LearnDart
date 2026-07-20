// Segment tree: array-backed binary tree that answers arbitrary
// range-aggregate queries in O(log n) with O(log n) point updates.
//
// Layout: the leaves live in [n, 2n) and each internal node at
// index i is the aggregate of its two children (2i and 2i+1). The
// aggregate function here is `+` (range sum), but the same structure
// works for min/max/gcd/xor — any *associative* operation.
//
// The iterative range-query walk is a beautiful piece of code: at
// each level, pull in the odd-indexed left boundary (it's a "right
// child" whose sibling belongs to a different subtree) and the even-
// indexed right boundary, then climb up. See
// data_structures/fenwick_tree.dart for a lighter alternative when
// you only need prefix-sum queries.
//
// Complexity: O(n) build, O(log n) update, O(log n) query.
class SegmentTree {
  final int _n;
  final List<int> _tree;

  SegmentTree(List<int> data)
      : _n = data.length,
        _tree = List<int>.filled(data.length * 2, 0) {
    for (int i = 0; i < _n; i++) _tree[_n + i] = data[i];
    for (int i = _n - 1; i > 0; i--) _tree[i] = _tree[2 * i] + _tree[2 * i + 1];
  }

  void update(int index, int value) {
    int i = index + _n;
    _tree[i] = value;
    for (i ~/= 2; i > 0; i ~/= 2) {
      _tree[i] = _tree[2 * i] + _tree[2 * i + 1];
    }
  }

  int rangeSum(int l, int r) {
    int sum = 0;
    int lo = l + _n;
    int hi = r + _n;
    while (lo <= hi) {
      if (lo & 1 == 1) sum += _tree[lo++];
      if (hi & 1 == 0) sum += _tree[hi--];
      lo ~/= 2;
      hi ~/= 2;
    }
    return sum;
  }
}

void main() {
  final st = SegmentTree([1, 3, 5, 7, 9, 11]);
  print(st.rangeSum(1, 3)); // 15  (3+5+7)
  st.update(1, 10);
  print(st.rangeSum(1, 3)); // 22  (10+5+7)
  print(st.rangeSum(0, 5)); // 43  (1+10+5+7+9+11)
}
