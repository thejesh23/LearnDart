// The spread operator `...` unpacks one collection inside another. `...?`
// does the same but skips gracefully when the source is null.
void main() {
  List<int> a = [1, 2, 3];
  List<int> b = [4, 5];
  List<int>? maybeMore; // stays null

  List<int> combined = [0, ...a, ...b, 6, ...?maybeMore];
  print(combined); // [0, 1, 2, 3, 4, 5, 6]

  // Works for sets and maps too.
  Set<String> lettersA = {'a', 'b'};
  Set<String> lettersB = {'b', 'c'};
  Set<String> allLetters = {...lettersA, ...lettersB};
  print(allLetters); // {a, b, c}
}
