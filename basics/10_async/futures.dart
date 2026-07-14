// A `Future<T>` represents a value that isn't ready yet — the result of
// work that will finish later, like a network request or a timer. You
// react to it by attaching `.then(...)` to be called when it completes.
//
// The `async/await` file shows a nicer syntax for the same idea.
Future<String> fetchGreeting() {
  return Future.delayed(
    const Duration(seconds: 1),
    () => 'Hello from the future!',
  );
}

void main() {
  print('asking...');
  fetchGreeting().then((greeting) {
    print('got: $greeting');
  });
  print('did not block the rest of main');
}
