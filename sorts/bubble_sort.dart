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
