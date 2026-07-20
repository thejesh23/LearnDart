// Circular doubly linked list: like a doubly linked list, but the
// tail's `next` points back to the head and the head's `prev` points
// to the tail. No null pointers on either end — every node has valid
// `prev` and `next`, always.
//
// The natural structure for round-robin scheduling: each cycle of
// `rotateLeft()` visits the next process, indefinitely. Also used
// for Josephus-problem simulations, running one-past-the-end music
// playlist advance, and any "circular buffer of objects" (not to be
// confused with the array-backed ring buffer in
// data_structures/circular_queue.dart, which is fixed-capacity and
// uses modular indexing rather than pointers).
//
// Complexity: O(1) append, O(1) rotate, O(n) traversal.
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
