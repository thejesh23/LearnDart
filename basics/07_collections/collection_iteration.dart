// Every collection in Dart is `Iterable`, meaning you can walk through it
// with `for-in` or with methods like `forEach`, `map`, `where`, `reduce`.
void main() {
  final words = ['apple', 'banana', 'cherry'];

  // for-in
  for (final w in words) {
    print('for-in: $w');
  }

  // forEach with a lambda
  words.forEach((w) => print('forEach: $w'));

  // Combined transform + filter + reduce
  final totalLetters = words
      .where((w) => w.startsWith('a') || w.startsWith('b'))
      .map((w) => w.length)
      .reduce((a, b) => a + b);

  print('total letters in a/b words: $totalLetters');

  // Maps iterate over entries.
  final ages = {'Ada': 36, 'Alan': 41};
  ages.forEach((name, age) => print('$name is $age'));
}
