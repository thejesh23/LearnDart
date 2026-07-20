// Quicksort: pick a pivot, partition the array so everything ≤ pivot
// comes first, then recurse on each partition. In-place, cache-friendly,
// and *usually* the fastest general-purpose sort in practice.
//
// Uses the Lomuto partition scheme with the last element as the pivot
// — the simplest to code and reason about. It has a nasty worst case:
// on already-sorted input the pivot is always the maximum, partitions
// are size (n-1, 0), and complexity degrades to O(n^2). Production
// implementations pick the pivot via median-of-three, random selection,
// or introsort's fallback to heap sort when recursion depth explodes.
//
// Complexity: O(n log n) average, O(n^2) worst, O(log n) stack space
// average. Not stable. See sorts/merge_sort.dart for the guaranteed-
// O(n log n) alternative.
List<int> quickSort(List<int> input) {
  final a = List<int>.of(input);
  _quickSort(a, 0, a.length - 1);
  return a;
}

void _quickSort(List<int> a, int lo, int hi) {
  if (lo >= hi) return;
  final p = _partition(a, lo, hi);
  _quickSort(a, lo, p - 1);
  _quickSort(a, p + 1, hi);
}

int _partition(List<int> a, int lo, int hi) {
  final pivot = a[hi];
  int i = lo - 1;
  for (int j = lo; j < hi; j++) {
    if (a[j] <= pivot) {
      i++;
      final t = a[i]; a[i] = a[j]; a[j] = t;
    }
  }
  final t = a[i + 1]; a[i + 1] = a[hi]; a[hi] = t;
  return i + 1;
}

void main() {
  print(quickSort([10, 7, 8, 9, 1, 5]));
  print(quickSort([2, 2, 2, 1]));
}
