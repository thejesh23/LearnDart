// Selection sort: for each position i, scan the unsorted tail for the
// smallest element and swap it into place.
//
// Simple, easy to prove correct, and does at most n - 1 swaps — one per
// outer iteration. That "few writes" property makes it the right pick
// when writes are far more expensive than comparisons (e.g. writing to
// EEPROM or flash). Otherwise, insertion sort is a strict upgrade on
// almost every axis.
//
// Complexity: O(n^2) comparisons always (no early exit possible),
// O(n) swaps, O(1) extra space. Not stable in the simple form shown
// here (the swap can leap over equal elements).
List<int> selectionSort(List<int> input) {
  final a = List<int>.of(input);
  for (int i = 0; i < a.length - 1; i++) {
    int minIdx = i;
    for (int j = i + 1; j < a.length; j++) {
      if (a[j] < a[minIdx]) minIdx = j;
    }
    if (minIdx != i) {
      final tmp = a[i];
      a[i] = a[minIdx];
      a[minIdx] = tmp;
    }
  }
  return a;
}

void main() {
  print(selectionSort([64, 25, 12, 22, 11]));
  print(selectionSort([3, 3, 3]));
}
