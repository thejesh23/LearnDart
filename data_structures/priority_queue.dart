// Generic priority queue implemented on top of a binary heap. Items are
// ordered by the caller-supplied comparator — the "smallest" item is at
// the front, so pass a reversed comparator for a max-priority queue.
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
