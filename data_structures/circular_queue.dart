// Fixed-capacity ring buffer / circular queue. O(1) enqueue and dequeue.
class CircularQueue<T> {
  final List<T?> _buf;
  int _head = 0;
  int _tail = 0;
  int _count = 0;

  CircularQueue(int capacity) : _buf = List<T?>.filled(capacity, null);

  bool get isEmpty => _count == 0;
  bool get isFull => _count == _buf.length;
  int get length => _count;

  void enqueue(T v) {
    if (isFull) throw StateError('queue is full');
    _buf[_tail] = v;
    _tail = (_tail + 1) % _buf.length;
    _count++;
  }

  T dequeue() {
    if (isEmpty) throw StateError('queue is empty');
    final v = _buf[_head] as T;
    _buf[_head] = null;
    _head = (_head + 1) % _buf.length;
    _count--;
    return v;
  }

  T peek() {
    if (isEmpty) throw StateError('queue is empty');
    return _buf[_head] as T;
  }
}

void main() {
  final q = CircularQueue<int>(3);
  q.enqueue(1); q.enqueue(2); q.enqueue(3);
  print(q.dequeue()); // 1
  q.enqueue(4);
  print(q.dequeue()); // 2
  print(q.peek());    // 3
}
