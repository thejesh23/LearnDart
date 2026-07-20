// Pancake sort: only allowed operation is `flip(k)` — reverse the first
// k elements. Repeatedly bring the max of the unsorted prefix to index 0
// then flip it to its final position.
void _flip(List<int> a, int k) {
  int i = 0, j = k;
  while (i < j) {
    final t = a[i]; a[i] = a[j]; a[j] = t;
    i++; j--;
  }
}

int _indexOfMax(List<int> a, int endInclusive) {
  int idx = 0;
  for (int i = 1; i <= endInclusive; i++) {
    if (a[i] > a[idx]) idx = i;
  }
  return idx;
}

List<int> pancakeSort(List<int> input) {
  final a = List<int>.of(input);
  for (int size = a.length; size > 1; size--) {
    final mi = _indexOfMax(a, size - 1);
    if (mi != size - 1) {
      if (mi != 0) _flip(a, mi);
      _flip(a, size - 1);
    }
  }
  return a;
}

void main() {
  print(pancakeSort([3, 6, 1, 10, 8, 2, 7]));
}
