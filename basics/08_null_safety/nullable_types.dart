// Dart tracks whether a value can be `null` in the *type*. Adding `?` to a
// type says "this value might be null." Without `?`, the compiler refuses
// to let you assign null to it. This is called *sound null safety* and it
// catches whole categories of bugs before you run the program.
void main() {
  String definitely = 'always here';
  String? maybeName;              // starts as null
  print('definitely = $definitely');
  print('maybeName  = $maybeName'); // null

  maybeName = 'Ada';
  print('maybeName  = $maybeName'); // Ada

  // definitely = null; // <-- won't compile; the type has no `?`
}
