List<int> shellSort(List<int> input) {
  final a = List<int>.of(input);
  int gap = a.length ~/ 2;
  while (gap > 0) {
    for (int i = gap; i < a.length; i++) {
      final temp = a[i];
      int j = i;
      while (j >= gap && a[j - gap] > temp) {
        a[j] = a[j - gap];
        j -= gap;
      }
      a[j] = temp;
    }
    gap ~/= 2;
  }
  return a;
}

void main() {
  print(shellSort([9, 8, 3, 7, 5, 6, 4, 1]));
}
