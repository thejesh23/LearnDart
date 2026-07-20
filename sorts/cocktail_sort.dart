// Cocktail shaker sort: bidirectional bubble sort. Each pass bubbles the
// max to the right, then the min to the left. Reduces the number of passes
// needed on partially-sorted inputs.
List<int> cocktailSort(List<int> input) {
  final a = List<int>.of(input);
  int start = 0;
  int end = a.length - 1;
  bool swapped = true;
  while (swapped) {
    swapped = false;
    for (int i = start; i < end; i++) {
      if (a[i] > a[i + 1]) {
        final t = a[i]; a[i] = a[i + 1]; a[i + 1] = t;
        swapped = true;
      }
    }
    if (!swapped) break;
    swapped = false;
    end--;
    for (int i = end - 1; i >= start; i--) {
      if (a[i] > a[i + 1]) {
        final t = a[i]; a[i] = a[i + 1]; a[i + 1] = t;
        swapped = true;
      }
    }
    start++;
  }
  return a;
}

void main() {
  print(cocktailSort([5, 1, 4, 2, 8, 0, 2]));
}
