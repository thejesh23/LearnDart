// FIFO queue: first-in, first-out. Enqueue adds to the back, dequeue
// removes from the front.
//
// A naive implementation on top of a List would have O(n) dequeue
// (shifting every element left after removeFirst). This wraps
// dart:collection's `Queue`, which is a doubly-linked list under
// the hood — O(1) at both ends.
//
// Central to BFS (graphs/bfs.dart), task schedulers, buffered I/O
// pipelines, and any producer-consumer pattern. For a fixed-size
// version see data_structures/circular_queue.dart; for both-ended
// access see data_structures/deque.dart.
//
// Complexity: O(1) enqueue, dequeue, peek. O(n) space.

import 'dart:collection';

class FIFOQueue<T> {
  final Queue<T> _items = Queue<T>();

  void enqueue(T v) => _items.addLast(v);

  T dequeue() {
    if (_items.isEmpty) throw StateError('dequeue from empty queue');
    return _items.removeFirst();
  }

  T peek() {
    if (_items.isEmpty) throw StateError('peek on empty queue');
    return _items.first;
  }

  int get length => _items.length;
  bool get isEmpty => _items.isEmpty;

  @override
  String toString() => 'Queue(front -> $_items)';
}

void main() {
  final q = FIFOQueue<String>();
  q.enqueue('a'); q.enqueue('b'); q.enqueue('c');
  print(q);
  print('dequeue -> ${q.dequeue()}');
  print(q);
}
