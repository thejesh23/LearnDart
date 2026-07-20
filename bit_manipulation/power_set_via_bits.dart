// Enumerate the power set of `items` using a binary counter: the bit
// pattern of `mask` picks which elements are in the subset.
List<List<T>> powerSet<T>(List<T> items) {
  final n = items.length;
  final total = 1 << n;
  final result = <List<T>>[];
  for (int mask = 0; mask < total; mask++) {
    final subset = <T>[];
    for (int i = 0; i < n; i++) {
      if ((mask >> i) & 1 == 1) subset.add(items[i]);
    }
    result.add(subset);
  }
  return result;
}

void main() {
  for (final s in powerSet(['a', 'b', 'c'])) {
    print(s);
  }
}
