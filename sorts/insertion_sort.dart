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
