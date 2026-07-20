// Floyd's Tortoise and Hare — cycle detection in a singly-linked
// list in O(n) time and O(1) space. Published by Robert Floyd in
// the mid-1960s; sometimes called the "hare and tortoise" algorithm
// after Aesop's fable.
//
// The intuition:
//   Phase 1 — advance `slow` by one step and `fast` by two on each
//     iteration. If there's a cycle, they must eventually meet
//     inside it (the hare, moving twice as fast, laps the tortoise
//     once modulo the cycle length). If `fast` reaches null, no
//     cycle.
//   Phase 2 — reset `slow` to the head; move both pointers one
//     step at a time. They will meet at the *entry* of the cycle.
//
// Phase 2's correctness is a lovely bit of modular arithmetic:
// call the distance head → cycle-entry L, and cycle length C. At
// the meeting point in phase 1, slow has walked k = L + m·C steps
// for some m; setting slow back to head and advancing both by one
// makes them meet after exactly L more steps — at the entry node.
//
// Killer alternative: a `Set<Node>` — O(n) space but trivially
// correct. Use Floyd's when memory matters or the data set is
// astronomical. LeetCode #141 (detect), #142 (find entry).
class Node<T> {
  T value;
  Node<T>? next;
  Node(this.value);
}

bool hasCycle<T>(Node<T>? head) {
  var slow = head, fast = head;
  while (fast != null && fast.next != null) {
    slow = slow!.next;
    fast = fast.next!.next;
    if (identical(slow, fast)) return true;
  }
  return false;
}

Node<T>? cycleEntry<T>(Node<T>? head) {
  var slow = head, fast = head;
  while (fast != null && fast.next != null) {
    slow = slow!.next;
    fast = fast.next!.next;
    if (identical(slow, fast)) {
      var p = head;
      while (!identical(p, slow)) { p = p!.next; slow = slow!.next; }
      return p;
    }
  }
  return null;
}

void main() {
  final a = Node(1), b = Node(2), c = Node(3), d = Node(4), e = Node(5);
  a.next = b; b.next = c; c.next = d; d.next = e;
  print(hasCycle(a));           // false
  print(cycleEntry(a)?.value);  // null
  e.next = c;                   // wire tail back to c → cycle
  print(hasCycle(a));           // true
  print(cycleEntry(a)?.value);  // 3
}
