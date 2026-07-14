// `async` marks a function that returns a Future. Inside it, `await` pauses
// until a Future completes and gives you its value. The code reads top-to-
// bottom like synchronous code, but doesn't block the rest of the program.
Future<int> slowDouble(int n) async {
  await Future.delayed(const Duration(milliseconds: 300));
  return n * 2;
}

Future<void> main() async {
  print('start');
  final a = await slowDouble(5);
  final b = await slowDouble(a);
  print('slowDouble(slowDouble(5)) = $b');
  print('done');
}
