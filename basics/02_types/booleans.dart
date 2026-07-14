// A `bool` has exactly two values: `true` and `false`. Booleans are how
// programs make decisions.
//
// Dart is strict here: only `true` and `false` count as booleans. Numbers,
// strings, and `null` are NOT truthy or falsy — you must compare explicitly.
void main() {
  bool isSunny = true;
  bool isRaining = false;

  print('isSunny   = $isSunny');
  print('isRaining = $isRaining');

  // Combine booleans with `&&` (and), `||` (or), `!` (not).
  bool goodForPicnic = isSunny && !isRaining;
  print('good for a picnic? $goodForPicnic');

  // Comparisons produce booleans.
  int score = 85;
  bool passed = score >= 60;
  print('score $score passed? $passed');
}
