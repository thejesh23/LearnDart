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
