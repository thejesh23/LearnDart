// Recursively flatten an arbitrarily-nested list of Objects.
List<Object> flatten(List<Object> input) {
  final out = <Object>[];
  void walk(Object v) {
    if (v is List) {
      for (final e in v) walk(e as Object);
    } else {
      out.add(v);
    }
  }
  for (final e in input) walk(e);
  return out;
}

void main() {
  print(flatten([1, [2, [3, [4, 5]], 6], 7])); // [1, 2, 3, 4, 5, 6, 7]
  print(flatten(['a', ['b', ['c']], 'd']));    // [a, b, c, d]
}
