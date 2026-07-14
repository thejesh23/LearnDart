// Enumerate the power set of a list — every 2^n possible subset.
List<List<T>> subsets<T>(List<T> items) {
  final result = <List<T>>[];
  void build(int i, List<T> current) {
    if (i == items.length) {
      result.add(List<T>.of(current));
      return;
    }
    build(i + 1, current);
    current.add(items[i]);
    build(i + 1, current);
    current.removeLast();
  }
  build(0, []);
  return result;
}

void main() {
  for (final s in subsets(['a', 'b', 'c'])) {
    print(s);
  }
}
