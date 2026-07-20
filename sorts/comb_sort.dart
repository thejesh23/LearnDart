// Comb sort: bubble sort with a shrinking gap. The gap starts at n and
// shrinks by a factor of 1.3 each pass, eliminating small values ("turtles")
// at the end of the array early.
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
