// Recursively flatten an arbitrarily-nested list of Objects into a
// single flat list, preserving element order.
//
// The recursion follows the structure of the data: for each element,
// either it's a list (recurse into it) or a leaf (append). This is a
// pattern you'll re-encounter constantly — tree traversal, XML/JSON
// walkers, expression evaluators — the recursion shape is dictated by
// the shape of the input, not by any clever algorithmic insight.
//
// Complexity: O(total number of leaves + nesting depth) time. The
// recursion depth equals the maximum nesting depth, so extremely deep
// inputs (thousands of nested levels) risk a stack overflow — rewrite
// with an explicit stack if you expect that.
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
