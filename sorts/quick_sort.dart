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
