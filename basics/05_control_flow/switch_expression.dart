// Dart 3 introduced switch *expressions*: a switch that produces a value
// instead of running statements. They pair beautifully with patterns and
// keep code compact.
//
// The `_` pattern is the wildcard — it matches anything, like `default`.
String describe(int n) => switch (n) {
      0 => 'zero',
      1 || 2 || 3 => 'small',
      < 0 => 'negative',
      _ => 'large or unusual',
    };

void main() {
  for (final n in [0, 2, -5, 100]) {
    print('$n -> ${describe(n)}');
  }
}
