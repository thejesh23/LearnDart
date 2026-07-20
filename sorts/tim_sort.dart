// Simplified TimSort. Two-phase structure:
//   1. Divide the array into "runs" of size minRun (32 here) and
//      insertion-sort each run.
//   2. Iteratively merge runs into larger sorted regions (like the
//      merge phase of merge sort).
//
// Real TimSort (Python's sorted() and Java's Arrays.sort() for
// objects, both since 2002) does much more: detects and preserves
// naturally occurring runs, keeps a stack of pending runs and merges
// them under specific invariants that keep merges balanced, uses
// "galloping" to skip long runs of elements from one side. The result
// is O(n log n) worst case but often O(n) on real-world data with
// existing partial order.
//
// This file shows the shape: insertion sort's speed on small ordered
// data + merge sort's structural guarantee. Complexity: O(n log n)
// worst, O(n) best, O(n) space. Stable.
const int _minRun = 32;

void _insertionSort(List<int> a, int left, int right) {
  for (int i = left + 1; i <= right; i++) {
    final key = a[i];
    int j = i - 1;
    while (j >= left && a[j] > key) {
      a[j + 1] = a[j];
      j--;
    }
    a[j + 1] = key;
  }
}

void _merge(List<int> a, int l, int m, int r) {
  final left = a.sublist(l, m + 1);
  final right = a.sublist(m + 1, r + 1);
  int i = 0, j = 0, k = l;
  while (i < left.length && j < right.length) {
    a[k++] = left[i] <= right[j] ? left[i++] : right[j++];
  }
  while (i < left.length) a[k++] = left[i++];
  while (j < right.length) a[k++] = right[j++];
}

List<int> timSort(List<int> input) {
  final a = List<int>.of(input);
  final n = a.length;
  for (int start = 0; start < n; start += _minRun) {
    final end = (start + _minRun - 1 < n - 1) ? start + _minRun - 1 : n - 1;
    _insertionSort(a, start, end);
  }
  for (int size = _minRun; size < n; size *= 2) {
    for (int left = 0; left < n; left += 2 * size) {
      final mid = left + size - 1;
      final right = (left + 2 * size - 1 < n - 1) ? left + 2 * size - 1 : n - 1;
      if (mid < right) _merge(a, left, mid, right);
    }
  }
  return a;
}

void main() {
  print(timSort([5, 21, 7, 23, 19, 10, 12, 1, 15, 3, 8, 9]));
}
