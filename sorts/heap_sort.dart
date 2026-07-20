// Heap sort: turn the array into a max-heap in-place (bottom-up
// heapify, O(n)), then repeatedly swap the top with the last unsorted
// slot and sift-down the new root. Each extraction places one more
// element in its final position.
//
// Guaranteed O(n log n) worst case (unlike quicksort) and O(1) extra
// space (unlike merge sort). But it's slower than quicksort in
// practice because it thrashes the cache — each sift-down bounces
// between memory locations far apart in the array — and its
// comparisons are more expensive per element.
//
// Used inside introsort as the fallback when quicksort's recursion
// depth exceeds 2 · log n, guaranteeing overall O(n log n). Also the
// natural sort you get if you push every element into a priority
// queue and pop them all off. Not stable.
List<int> heapSort(List<int> input) {
  final a = List<int>.of(input);
  final n = a.length;
  for (int i = n ~/ 2 - 1; i >= 0; i--) {
    _siftDown(a, i, n);
  }
  for (int end = n - 1; end > 0; end--) {
    final t = a[0]; a[0] = a[end]; a[end] = t;
    _siftDown(a, 0, end);
  }
  return a;
}

void _siftDown(List<int> a, int root, int end) {
  int i = root;
  while (true) {
    final left = 2 * i + 1;
    final right = 2 * i + 2;
    int largest = i;
    if (left < end && a[left] > a[largest]) largest = left;
    if (right < end && a[right] > a[largest]) largest = right;
    if (largest == i) return;
    final t = a[i]; a[i] = a[largest]; a[largest] = t;
    i = largest;
  }
}

void main() {
  print(heapSort([12, 11, 13, 5, 6, 7]));
}
