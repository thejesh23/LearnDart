// Fenwick tree (Binary Indexed Tree) for prefix-sum queries and point
// updates. O(log n) per operation. 1-indexed internally.
class FenwickTree {
  final List<int> _bit;

  FenwickTree(int size) : _bit = List<int>.filled(size + 1, 0);

  void update(int i, int delta) {
    for (int x = i + 1; x < _bit.length; x += x & -x) {
      _bit[x] += delta;
    }
  }

  int prefixSum(int i) {
    int sum = 0;
    for (int x = i + 1; x > 0; x -= x & -x) {
      sum += _bit[x];
    }
    return sum;
  }

  int rangeSum(int l, int r) => prefixSum(r) - (l > 0 ? prefixSum(l - 1) : 0);
}

void main() {
  final f = FenwickTree(6);
  final data = [1, 3, 5, 7, 9, 11];
  for (int i = 0; i < data.length; i++) f.update(i, data[i]);
  print(f.rangeSum(1, 3)); // 15
  f.update(1, 7);          // data[1] becomes 3+7 = 10
  print(f.rangeSum(1, 3)); // 22
}
