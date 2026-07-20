// Cocktail shaker sort (a.k.a. bidirectional bubble sort). Alternate
// left-to-right and right-to-left passes, each swapping adjacent
// out-of-order pairs.
//
// The single-direction bubble sort has "turtle" problem: a small
// element at the end takes n passes to migrate to the front, one step
// per pass. Cocktail sort fixes this by giving small elements their
// own leftward passes — turtles reach the front twice as fast.
//
// Same asymptotic O(n^2) worst case as bubble sort, but modestly
// better constant factors and much better on nearly-sorted inputs.
// Still not competitive with insertion sort for most uses. Complexity:
// O(n^2) worst, O(n) best, O(1) space. Stable.
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
