// Bubble sort: repeatedly walk the list, swapping adjacent out-of-order
// pairs. After the k-th pass the largest k elements have "bubbled" to
// the end. The `swapped` flag lets us exit early when a pass completes
// with no swaps — best case O(n) on already-sorted input.
//
// Almost never the right choice in production: O(n^2) average, and
// insertion sort has the same complexity but roughly half the swaps.
// Included here because the "walk and swap adjacents" pattern is the
// mental model everyone starts with — and because the identical
// mental model, applied to a shrinking gap, gives comb sort.
//
// Complexity: O(n^2) time, O(1) space. Stable.
List<int> bubbleSort(List<int> input) {
  final a = List<int>.of(input);
  for (int i = 0; i < a.length - 1; i++) {
    bool swapped = false;
    for (int j = 0; j < a.length - 1 - i; j++) {
      if (a[j] > a[j + 1]) {
        final tmp = a[j];
        a[j] = a[j + 1];
        a[j + 1] = tmp;
        swapped = true;
      }
    }
    if (!swapped) break;
  }
  return a;
}

void main() {
  print(bubbleSort([5, 2, 9, 1, 7, 3]));
  print(bubbleSort([]));
  print(bubbleSort([1]));
}
