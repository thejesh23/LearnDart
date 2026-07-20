// Binary min-heap stored as an array. For any index i, its children
// are at 2i+1 and 2i+2 and its parent is at (i-1)/2. The heap
// property: every parent is ≤ its children.
//
// The array layout means no pointers, no per-node overhead, and
// perfect cache locality. Push (sift-up) and pop (sift-down) each
// take O(log n) — one round trip along a path from the leaf to the
// root or vice versa.
//
// Building block for priority queues (Dijkstra, A*, Huffman), the
// standard trick for "top-k largest" (use a size-k min-heap and
// discard anything smaller than the top). See
// data_structures/max_heap.dart for the sibling, and
// data_structures/priority_queue.dart for a generic wrapper.

class MinHeap {
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
      if (_data[i] >= _data[parent]) return;
      final t = _data[i]; _data[i] = _data[parent]; _data[parent] = t;
      i = parent;
    }
  }

  void _siftDown(int i) {
    final n = _data.length;
    while (true) {
      final l = 2 * i + 1;
      final r = 2 * i + 2;
      int smallest = i;
      if (l < n && _data[l] < _data[smallest]) smallest = l;
      if (r < n && _data[r] < _data[smallest]) smallest = r;
      if (smallest == i) return;
      final t = _data[i]; _data[i] = _data[smallest]; _data[smallest] = t;
      i = smallest;
    }
  }
}

void main() {
  final h = MinHeap();
  for (final v in [5, 3, 8, 1, 9, 2]) h.push(v);
  final popped = <int>[];
  while (!h.isEmpty) popped.add(h.pop());
  print(popped); // [1, 2, 3, 5, 8, 9]
}
