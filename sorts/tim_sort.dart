// Simplified TimSort: insertion sort on fixed-size runs, then merge them.
// Not the full CPython/JDK TimSort — enough to convey the shape.
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
