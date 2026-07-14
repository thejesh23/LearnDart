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
