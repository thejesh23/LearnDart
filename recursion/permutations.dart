List<List<T>> permutations<T>(List<T> items) {
  if (items.length <= 1) return [List.of(items)];
  final out = <List<T>>[];
  for (int i = 0; i < items.length; i++) {
    final rest = [...items.sublist(0, i), ...items.sublist(i + 1)];
    for (final perm in permutations(rest)) {
      out.add([items[i], ...perm]);
    }
  }
  return out;
}

void main() {
  for (final p in permutations(['a', 'b', 'c'])) {
    print(p);
  }
}
