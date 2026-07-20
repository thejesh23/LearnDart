// Deque (double-ended queue): enqueue and dequeue from either end
// with O(1) time. Union of stack and queue — a superset of both.
//
// Common uses beyond generic collections:
//   - Sliding-window maximum/minimum: maintain a monotonic deque
//     that yields window extremes in O(1) per shift.
//   - Palindrome detection: pop from both ends and compare.
//   - Work-stealing schedulers: each worker uses its own deque,
//     pushes/pops on one end normally, and steals from the other end.
//
// Backed here by dart:collection's DoubleLinkedQueue for guaranteed
// O(1) at both ends. A circular-buffer deque is also possible and
// even faster in practice for fixed maximum sizes (better cache
// behavior). Complexity: O(1) for all core ops.
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
