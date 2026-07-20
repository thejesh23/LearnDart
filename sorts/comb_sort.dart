// Comb sort: bubble sort but comparing elements a *gap* apart rather
// than always-adjacent. The gap starts at n and shrinks by a factor
// of 1.3 each pass, ending at 1 (a plain bubble pass) to catch any
// remaining out-of-order neighbors.
//
// Attacks bubble sort's "turtle" problem — small values near the end
// of the array that migrate one step per pass. Non-unit gaps let
// them leap most of the way home in a single comparison. Empirically,
// 1.3 is the shrink factor that minimizes work; the paper that
// introduced comb sort (Lacey and Box, 1991) found it experimentally.
//
// Complexity: O(n^2 / 2^p) with p related to the shrink factor —
// somewhere around O(n log n) on random data in practice but O(n^2)
// worst case. Rarely used in production, but a nice contrast with
// bubble sort. Not stable.
List<int> combSort(List<int> input) {
  final a = List<int>.of(input);
  int gap = a.length;
  const shrink = 1.3;
  bool sorted = false;
  while (!sorted) {
    gap = (gap ~/ shrink);
    if (gap <= 1) { gap = 1; sorted = true; }
    for (int i = 0; i + gap < a.length; i++) {
      if (a[i] > a[i + gap]) {
        final t = a[i]; a[i] = a[i + gap]; a[i + gap] = t;
        sorted = false;
      }
    }
  }
  return a;
}

void main() {
  print(combSort([8, 4, 1, 56, 3, -44, 23, -6, 28, 0]));
}
