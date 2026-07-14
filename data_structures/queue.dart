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
