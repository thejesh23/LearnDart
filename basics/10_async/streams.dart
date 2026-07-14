// A `Stream<T>` is a sequence of values delivered over time — like a
// Future that yields more than once. Common sources: timers, file reads,
// user input, websockets. Use `await for` to consume one.
Stream<int> countdown(int from) async* {
  for (int i = from; i >= 0; i--) {
    await Future.delayed(const Duration(milliseconds: 200));
    yield i;
  }
}

Future<void> main() async {
  await for (final tick in countdown(3)) {
    print('tick: $tick');
  }
  print('boom');
}
