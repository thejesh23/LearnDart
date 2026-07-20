// Stack: last-in, first-out (LIFO) collection. Push adds to the top,
// pop removes from the top, peek looks without removing.
//
// The archetypal use case is anywhere you'd naturally use recursion:
// the call stack itself is exactly this data structure. Explicit
// stacks let you iteratively simulate what recursion does — useful
// when recursion depth would overflow or when you need control over
// the traversal order (DFS with an explicit stack, expression
// evaluation, undo history, matched-bracket checking).
//
// Backed by a growable List — push/pop at the *end* are O(1)
// amortized. All ops O(1) time, O(n) space. See
// strings/valid_parentheses.dart for a canonical application.

class Stack<T> {
  final List<T> _items = [];

  void push(T v) => _items.add(v);

  T pop() {
    if (_items.isEmpty) throw StateError('pop from empty stack');
    return _items.removeLast();
  }

  T peek() {
    if (_items.isEmpty) throw StateError('peek on empty stack');
    return _items.last;
  }

  int get length => _items.length;
  bool get isEmpty => _items.isEmpty;

  @override
  String toString() => 'Stack(top -> $_items)';
}

void main() {
  final s = Stack<int>();
  s.push(1); s.push(2); s.push(3);
  print(s);
  print('pop -> ${s.pop()}');
  print('peek -> ${s.peek()}');
  print(s);
}
