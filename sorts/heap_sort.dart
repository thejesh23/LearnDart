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
