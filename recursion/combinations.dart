List<List<T>> combinations<T>(List<T> items, int k) {
  if (k == 0) return [<T>[]];
  if (items.length < k) return const [];
  final out = <List<T>>[];
  for (int i = 0; i <= items.length - k; i++) {
    final head = items[i];
    for (final tail in combinations(items.sublist(i + 1), k - 1)) {
      out.add([head, ...tail]);
    }
  }
  return out;
}

void main() {
  for (final c in combinations([1, 2, 3, 4], 2)) {
    print(c);
  }
}
