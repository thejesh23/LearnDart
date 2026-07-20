// Circular doubly linked list: the tail's next points back to the head and
// the head's prev points to the tail. Useful for round-robin schedulers.
class _Node<T> {
  T value;
  _Node<T>? prev, next;
  _Node(this.value);
}

class CircularDoublyLinkedList<T> {
  _Node<T>? _head;
  int _length = 0;

  int get length => _length;
  bool get isEmpty => _head == null;

  void append(T v) {
    final n = _Node(v);
    if (_head == null) {
      _head = n;
      n.prev = n;
      n.next = n;
    } else {
      final tail = _head!.prev!;
      n.prev = tail;
      n.next = _head;
      tail.next = n;
      _head!.prev = n;
    }
    _length++;
  }

  T rotateLeft() {
    if (_head == null) throw StateError('list is empty');
    final v = _head!.value;
    _head = _head!.next;
    return v;
  }

  List<T> toList() {
    final out = <T>[];
    if (_head == null) return out;
    var cur = _head!;
    for (int i = 0; i < _length; i++) {
      out.add(cur.value);
      cur = cur.next!;
    }
    return out;
  }
}

void main() {
  final list = CircularDoublyLinkedList<String>();
  for (final w in ['a', 'b', 'c', 'd']) list.append(w);
  print(list.toList());
  print('rotate: ${list.rotateLeft()}');
  print(list.toList());
}
