// Singly linked list: chain of nodes, each holding a value and a
// pointer to the next. No random access — everything is linear.
//
// Rarely the right choice today: dynamic arrays (List / ArrayList /
// std::vector) beat linked lists on almost every real-world workload
// because they're contiguous in memory and CPU caches love that.
// Linked lists shine only when you need O(1) insertion/deletion at
// arbitrary positions *given* a node pointer, or when you're building
// something intrinsically linked (persistent data structures, some
// concurrent lock-free queues).
//
// Complexity: prepend O(1), append O(n), remove O(n), search O(n).
// See data_structures/doubly_linked_list.dart for the two-pointer
// variant that supports O(1) backward traversal.

class Node<T> {
  T value;
  Node<T>? next;
  Node(this.value, [this.next]);
}

class LinkedList<T> {
  Node<T>? head;

  void prepend(T v) => head = Node(v, head);

  void append(T v) {
    final node = Node(v);
    if (head == null) { head = node; return; }
    var cur = head!;
    while (cur.next != null) cur = cur.next!;
    cur.next = node;
  }

  bool remove(T v) {
    if (head == null) return false;
    if (head!.value == v) { head = head!.next; return true; }
    var cur = head!;
    while (cur.next != null) {
      if (cur.next!.value == v) { cur.next = cur.next!.next; return true; }
      cur = cur.next!;
    }
    return false;
  }

  List<T> toList() {
    final out = <T>[];
    for (var n = head; n != null; n = n.next) out.add(n.value);
    return out;
  }
}

void main() {
  final list = LinkedList<int>();
  list.append(1); list.append(2); list.append(3);
  list.prepend(0);
  print(list.toList()); // [0, 1, 2, 3]
  list.remove(2);
  print(list.toList()); // [0, 1, 3]
}
