// Insertion sort: grow a sorted prefix one element at a time by taking
// the next element and sliding it left until it's in its right spot.
// The way most people sort a hand of playing cards.
//
// Best-case O(n) on already-sorted input (each element only compares
// once). Worst-case O(n^2) on reverse-sorted. Adaptive — the more
// nearly-sorted the input, the closer you get to linear.
//
// This is why it's the "small array" base case inside almost every
// production sort — TimSort switches to insertion for runs under 32
// or 64 elements (see sorts/tim_sort.dart), quicksort switches to
// it below some threshold too. Complexity: O(n^2) worst, O(n) best,
// O(1) space. Stable.
List<int> insertionSort(List<int> input) {
  final a = List<int>.of(input);
  for (int i = 1; i < a.length; i++) {
    final key = a[i];
    int j = i - 1;
    while (j >= 0 && a[j] > key) {
      a[j + 1] = a[j];
      j--;
    }
    a[j + 1] = key;
  }
  return a;
}

void main() {
  print(insertionSort([12, 11, 13, 5, 6]));
  print(insertionSort([5, 4, 3, 2, 1]));
}
