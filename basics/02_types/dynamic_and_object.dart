// Sometimes you truly don't know what type a value will have — for example,
// data coming from a JSON file. Dart offers two escape hatches:
//
//   Object  — "any non-null value". You must cast before calling methods
//             that only exist on the specific type.
//   dynamic — "trust me, I know what I'm doing". Dart skips type checks
//             at compile time; you find out at runtime if you were wrong.
//
// Prefer specific types when you can. `dynamic` is powerful but easy to
// misuse: you lose the safety net the compiler normally gives you.
void main() {
  Object anObject = 'a string';
  dynamic anything = 42;

  print(anObject);
  print(anything);

  anything = 'now I am a string';
  print(anything);

  // With `dynamic`, this compiles — but would crash at runtime if `anything`
  // were not actually a String at the moment of the call:
  print(anything.toUpperCase());

  // With `Object`, we must check the type first.
  if (anObject is String) {
    print(anObject.toUpperCase()); // Dart narrows the type inside the `if`
  }
}
