List<int> mergeSort(List<int> input) {
  if (input.length <= 1) return List<int>.of(input);
  final mid = input.length ~/ 2;
  final left = mergeSort(input.sublist(0, mid));
  final right = mergeSort(input.sublist(mid));
  return _merge(left, right);
}

List<int> _merge(List<int> left, List<int> right) {
  final out = <int>[];
  int i = 0, j = 0;
  while (i < left.length && j < right.length) {
    if (left[i] <= right[j]) {
      out.add(left[i++]);
    } else {
      out.add(right[j++]);
    }
  }
  out.addAll(left.sublist(i));
  out.addAll(right.sublist(j));
  return out;
}

void main() {
  print(mergeSort([38, 27, 43, 3, 9, 82, 10]));
  print(mergeSort([1]));
}
