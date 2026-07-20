// Doubly linked list: each node has a `next` and a `prev` pointer.
// Trades memory (extra pointer per node) for O(1) backward traversal
// and O(1) removal given a node pointer.
//
// Standard interior of dart:collection's DoubleLinkedQueue, C++'s
// std::list, and Python's collections.deque. Also the basis of the
// LRU cache — see data_structures/lru_cache.dart — where you need
// O(1) removal from anywhere in the list.
//
// The bookkeeping gotcha: on insertion or removal, remember to
// update both directions and both endpoints. `head` and `tail`
// pointers can slip out of sync easily on the empty-list and
// single-node edge cases.
//
// Complexity: O(1) prepend, append, and removal-given-node.

class DNode<T> {
  T value;
  DNode<T>? prev;
  DNode<T>? next;
  DNode(this.value);
}

class DoublyLinkedList<T> {
  DNode<T>? head;
  DNode<T>? tail;

  void append(T v) {
    final n = DNode(v);
    if (tail == null) { head = n; tail = n; return; }
    n.prev = tail;
    tail!.next = n;
    tail = n;
  }

  void prepend(T v) {
    final n = DNode(v);
    if (head == null) { head = n; tail = n; return; }
    n.next = head;
    head!.prev = n;
    head = n;
  }

  List<T> toListForward() {
    final out = <T>[];
    for (var n = head; n != null; n = n.next) out.add(n.value);
    return out;
  }

  List<T> toListBackward() {
    final out = <T>[];
    for (var n = tail; n != null; n = n.prev) out.add(n.value);
    return out;
  }
}

void main() {
  final list = DoublyLinkedList<String>();
  list.append('b'); list.append('c'); list.prepend('a');
  print('forward:  ${list.toListForward()}');   // [a, b, c]
  print('backward: ${list.toListBackward()}');  // [c, b, a]
}
