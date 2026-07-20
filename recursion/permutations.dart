// Generate every permutation of a list — every possible ordering of its
// elements. For a list of length n there are n! permutations.
//
// The recursion is "pick any element as the first, then recursively
// permute the rest, then paste the picked element back on the front".
// This produces permutations in lexicographic order when the input is
// sorted.
//
// Complexity: O(n · n!) time (n! permutations, each of length n) and
// O(n · n!) space to hold all of them. For large n, prefer Heap's
// algorithm or an iterator that yields one permutation at a time.
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
