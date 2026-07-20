// Double-ended queue: enqueue and dequeue from either end. Backed by
// dart:collection's DoubleLinkedQueue which gives O(1) ops on both ends.
import 'dart:collection';

class Deque<T> {
  final DoubleLinkedQueue<T> _q = DoubleLinkedQueue<T>();

  void pushFront(T v) => _q.addFirst(v);
  void pushBack(T v) => _q.addLast(v);

  T popFront() {
    if (_q.isEmpty) throw StateError('deque is empty');
    return _q.removeFirst();
  }

  T popBack() {
    if (_q.isEmpty) throw StateError('deque is empty');
    return _q.removeLast();
  }

  T peekFront() => _q.first;
  T peekBack() => _q.last;

  int get length => _q.length;
  bool get isEmpty => _q.isEmpty;

  @override
  String toString() => 'Deque($_q)';
}

void main() {
  final d = Deque<int>();
  d.pushBack(1); d.pushBack(2); d.pushBack(3);
  d.pushFront(0);
  print(d);              // [0, 1, 2, 3]
  print(d.popFront());   // 0
  print(d.popBack());    // 3
  print(d);              // [1, 2]
}
