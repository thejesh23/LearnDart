// Pancake sort: the only operation allowed is `flip(k)` — reverse the
// first k elements of the array (imagine a stack of pancakes and a
// spatula). Sort using flips alone.
//
// Algorithm: to sort the last n positions, find the max in the
// unsorted prefix, flip it to index 0, then flip the whole unsorted
// prefix to send it to the end. Repeat with a smaller prefix.
//
// Famous mostly for the "burnt pancake" variant that Bill Gates
// worked on as an undergrad — his 1979 paper is his only academic
// publication. Practical uses are rare (this is a puzzle, not a
// speed sort), but it's the natural model for any device whose only
// operation is a prefix reversal — including some parallel-processor
// architectures. Complexity: O(n^2) time, O(1) space. Not stable.
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
