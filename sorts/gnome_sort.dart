// Gnome sort (aka "stupid sort"), named for the Dutch garden-gnome
// analogy: a gnome sorts a row of flower pots by walking left-to-
// right; whenever the pot at position i is out of order relative
// to i-1, he swaps them and walks one step *backward*; otherwise
// he walks forward. Repeat until he's off the right end.
//
// Simpler than insertion sort — no nested loops, no separate
// "shift" and "compare" phases — but same big-O: O(n²) worst
// case, O(n) on already-sorted input. Instructive as a minimalist
// baseline. It is stable (swaps only adjacent elements) and in-
// place.
//
// See sorts/insertion_sort.dart and sorts/bubble_sort.dart for
// its natural neighbours.
void gnomeSort(List<int> arr) {
  int i = 0;
  while (i < arr.length) {
    if (i == 0 || arr[i - 1] <= arr[i]) {
      i++;
    } else {
      final tmp = arr[i - 1];
      arr[i - 1] = arr[i];
      arr[i] = tmp;
      i--;
    }
  }
}

void main() {
  final xs = [10, 34, 6, 323, 7, 1, 88, 25];
  gnomeSort(xs);
  print(xs);  // [1, 6, 7, 10, 25, 34, 88, 323]

  final empty = <int>[];
  gnomeSort(empty);
  print(empty);  // []
}
