// The `!` operator (the "bang") tells Dart: "I know this looks nullable,
// but I promise it is not null right now — trust me." If your promise is
// wrong, the program throws at runtime.
//
// Use it sparingly. Prefer an explicit null check or `??` fallback when
// you can.
int? findAge(String name) {
  final ages = {'Ada': 36, 'Alan': 41};
  return ages[name]; // returns null if the key is missing
}

void main() {
  int age = findAge('Ada')!; // safe: 'Ada' is in the map
  print("Ada's age: $age");

  try {
    int missing = findAge('Nobody')!; // crashes: value is null
    print(missing);
  } catch (e) {
    print('caught: $e');
  }
}
