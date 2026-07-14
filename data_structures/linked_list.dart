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
