// Merge sort: split the list in half, sort each half recursively, then
// merge the two sorted halves. A textbook divide-and-conquer algorithm
// invented by John von Neumann in 1945.
//
// Guaranteed O(n log n) on every input — no adversarial case that
// pushes it to O(n^2), unlike quicksort. That predictability is why
// TimSort uses merge sort as its high-level structure and why external
// sorts of massive datasets always end up as k-way merges.
//
// Downside: needs O(n) auxiliary space for the merge buffer, and
// naive recursion allocates a lot. Complexity: O(n log n) time,
// O(n) space. Stable — the `<=` in the merge preserves equal-key
// order from the left half.
List<int> mergeSort(List<int> input) {
  if (input.length <= 1) return List<int>.of(input);
  final mid = input.length ~/ 2;
  final left = mergeSort(input.sublist(0, mid));
  final right = mergeSort(input.sublist(mid));
  return _merge(left, right);
}

List<int> _merge(List<int> left, List<int> right) {
  final out = <int>[];
  int i = 0, j = 0;
  while (i < left.length && j < right.length) {
    if (left[i] <= right[j]) {
      out.add(left[i++]);
    } else {
      out.add(right[j++]);
    }
  }
  out.addAll(left.sublist(i));
  out.addAll(right.sublist(j));
  return out;
}

void main() {
  print(mergeSort([38, 27, 43, 3, 9, 82, 10]));
  print(mergeSort([1]));
}
