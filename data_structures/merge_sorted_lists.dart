// Merge two sorted singly-linked lists into one sorted linked list.
// Same idea as merge-sort's merge step, but on linked nodes: no
// allocation for the merged list, we just re-link tails.
//
// The "dummy head" trick is the trick to know: allocate a throw-
// away Node upfront, keep a `tail` pointer, and append each next
// smaller node to `tail.next`. This eliminates the tedious "is the
// merged list currently empty?" branch. At the end, return
// `dummy.next`.
//
// Complexity: O(m + n) time, O(1) extra space (we reuse the
// existing nodes). The dual for arrays lives in sorts/merge_sort.dart.
// LeetCode #21.
class ListNode {
  int value;
  ListNode? next;
  ListNode(this.value, [this.next]);
}

ListNode? mergeTwoSortedLists(ListNode? a, ListNode? b) {
  final dummy = ListNode(0);
  var tail = dummy;
  while (a != null && b != null) {
    if (a.value <= b.value) {
      tail.next = a;
      a = a.next;
    } else {
      tail.next = b;
      b = b.next;
    }
    tail = tail.next!;
  }
  tail.next = a ?? b;
  return dummy.next;
}

List<int> _toList(ListNode? head) {
  final out = <int>[];
  while (head != null) { out.add(head.value); head = head.next; }
  return out;
}

ListNode? _fromList(List<int> values) {
  ListNode? head;
  for (int i = values.length - 1; i >= 0; i--) head = ListNode(values[i], head);
  return head;
}

void main() {
  final merged = mergeTwoSortedLists(_fromList([1, 2, 4]), _fromList([1, 3, 4]));
  print(_toList(merged));  // [1, 1, 2, 3, 4, 4]

  print(_toList(mergeTwoSortedLists(null, _fromList([1, 2, 3])))); // [1, 2, 3]
  print(_toList(mergeTwoSortedLists(_fromList([]), _fromList([])))); // []
}
