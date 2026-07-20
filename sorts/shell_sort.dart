// Shell sort: insertion sort applied over gaps that shrink toward 1.
// First pass sorts elements gap apart, next pass sorts elements gap/2
// apart, and so on. By the time gap = 1 the array is nearly sorted,
// so the final insertion pass runs almost linearly.
//
// Named for Donald Shell (1959) — the *first* sort to beat O(n^2).
// Complexity depends entirely on the gap sequence: with the naive
// halving gap used here it's roughly O(n^2), with Sedgewick's
// sequence it's O(n^(4/3)), with Ciura's it's near-O(n log^2 n).
// Nowhere near merge/quick sort asymptotically but very fast in
// practice for moderate n with tiny code size — a good pick for
// embedded systems. Complexity: depends on gap sequence, O(1) space.
List<int> shellSort(List<int> input) {
  final a = List<int>.of(input);
  int gap = a.length ~/ 2;
  while (gap > 0) {
    for (int i = gap; i < a.length; i++) {
      final temp = a[i];
      int j = i;
      while (j >= gap && a[j - gap] > temp) {
        a[j] = a[j - gap];
        j -= gap;
      }
      a[j] = temp;
    }
    gap ~/= 2;
  }
  return a;
}

void main() {
  print(shellSort([9, 8, 3, 7, 5, 6, 4, 1]));
}
