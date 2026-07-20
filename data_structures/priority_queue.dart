// Generic priority queue on top of a binary heap. Elements come out
// in the order defined by the caller-supplied comparator — pass
// `(a, b) => a.compareTo(b)` for a min-PQ, reversed for a max-PQ.
//
// Distinguishes itself from data_structures/min_heap.dart and
// data_structures/max_heap.dart by holding *arbitrary* generic
// values, not just ints. Insertion and extraction are O(log n) —
// the same sift-up/sift-down primitives, parameterized by the
// comparator instead of a hardcoded `<`.
//
// Central to shortest-path and MST algorithms (Dijkstra, Prim), to
// event-driven simulations (next event = smallest scheduled time),
// and to top-k queries. Complexity: O(log n) push and pop, O(1) peek.
class PriorityQueue<T> {
  final int Function(T a, T b) _compare;
  final List<T> _data = [];

  PriorityQueue(this._compare);

  int get length => _data.length;
  bool get isEmpty => _data.isEmpty;

  void push(T v) {
    _data.add(v);
    _siftUp(_data.length - 1);
  }

  T pop() {
    if (_data.isEmpty) throw StateError('pop from empty queue');
    final top = _data.first;
    final last = _data.removeLast();
    if (_data.isNotEmpty) {
      _data[0] = last;
      _siftDown(0);
    }
    return top;
  }

  T peek() {
    if (_data.isEmpty) throw StateError('peek on empty queue');
    return _data.first;
  }

  void _siftUp(int i) {
    while (i > 0) {
      final parent = (i - 1) ~/ 2;
      if (_compare(_data[i], _data[parent]) >= 0) return;
      final t = _data[i]; _data[i] = _data[parent]; _data[parent] = t;
      i = parent;
    }
  }

  void _siftDown(int i) {
    final n = _data.length;
    while (true) {
      final l = 2 * i + 1;
      final r = 2 * i + 2;
      int best = i;
      if (l < n && _compare(_data[l], _data[best]) < 0) best = l;
      if (r < n && _compare(_data[r], _data[best]) < 0) best = r;
      if (best == i) return;
      final t = _data[i]; _data[i] = _data[best]; _data[best] = t;
      i = best;
    }
  }
}

void main() {
  // Task queue by ascending priority.
  final pq = PriorityQueue<(int, String)>((a, b) => a.$1.compareTo(b.$1));
  pq.push((3, 'low-priority chore'));
  pq.push((1, 'urgent bug'));
  pq.push((2, 'planned refactor'));
  while (!pq.isEmpty) print(pq.pop());
}
