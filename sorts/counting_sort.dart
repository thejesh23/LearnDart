List<int> countingSort(List<int> input) {
  if (input.isEmpty) return [];
  final min = input.reduce((a, b) => a < b ? a : b);
  final max = input.reduce((a, b) => a > b ? a : b);
  final counts = List<int>.filled(max - min + 1, 0);
  for (final v in input) counts[v - min]++;
  final out = <int>[];
  for (int i = 0; i < counts.length; i++) {
    for (int k = 0; k < counts[i]; k++) out.add(i + min);
  }
  return out;
}

void main() {
  print(countingSort([4, 2, 2, 8, 3, 3, 1]));
  print(countingSort([-2, 0, -1, 3, 1]));
}
