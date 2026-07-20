// Binary max-heap — mirror of the min-heap with parent ≥ children.
// Same array layout, same sift-up/sift-down structure; the only
// difference is the direction of the comparison.
//
// Used in sorts/heap_sort.dart (repeatedly extract the max and put
// it at the end), and any "top-k smallest" query (invert the trick
// from min_heap.dart — use a size-k max-heap and discard anything
// larger than the top).
//
// Both variants are common enough that many libraries provide only
// one and expect callers to negate comparators for the other; see
// data_structures/priority_queue.dart for the polymorphic version.
// Complexity: O(log n) push and pop, O(1) peek.

class MaxHeap {
  final List<int> _data = [];

  int get length => _data.length;
  bool get isEmpty => _data.isEmpty;

  void push(int v) {
    _data.add(v);
    _siftUp(_data.length - 1);
  }

  int pop() {
    if (_data.isEmpty) throw StateError('pop from empty heap');
    final top = _data.first;
    final last = _data.removeLast();
    if (_data.isNotEmpty) {
      _data[0] = last;
      _siftDown(0);
    }
    return top;
  }

  int peek() {
    if (_data.isEmpty) throw StateError('peek on empty heap');
    return _data.first;
  }

  void _siftUp(int i) {
    while (i > 0) {
      final parent = (i - 1) ~/ 2;
      if (_data[i] <= _data[parent]) return;
      final t = _data[i]; _data[i] = _data[parent]; _data[parent] = t;
      i = parent;
    }
  }

  void _siftDown(int i) {
    final n = _data.length;
    while (true) {
      final l = 2 * i + 1;
      final r = 2 * i + 2;
      int largest = i;
      if (l < n && _data[l] > _data[largest]) largest = l;
      if (r < n && _data[r] > _data[largest]) largest = r;
      if (largest == i) return;
      final t = _data[i]; _data[i] = _data[largest]; _data[largest] = t;
      i = largest;
    }
  }
}

void main() {
  final h = MaxHeap();
  for (final v in [5, 3, 8, 1, 9, 2]) h.push(v);
  final popped = <int>[];
  while (!h.isEmpty) popped.add(h.pop());
  print(popped); // [9, 8, 5, 3, 2, 1]
}
