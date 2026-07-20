// Recursive fast exponentiation. The recurrence:
//   x^0 = 1
//   x^n = (x^(n/2))^2         if n is even
//   x^n = (x^(n/2))^2 · x     if n is odd
//
// Same O(log exp) complexity as the iterative form
// (maths/power_iterative.dart). Recursion depth is also O(log exp),
// so no stack concerns.
//
// The recursive form makes the "each step halves the exponent"
// invariant visually explicit — one of the clearest illustrations
// of how a divide-and-conquer restructuring lifts an O(n) computation
// to O(log n).
int powerRecursive(int base, int exp) {
  if (exp < 0) throw ArgumentError('exp must be non-negative');
  if (exp == 0) return 1;
  final half = powerRecursive(base, exp ~/ 2);
  final sq = half * half;
  return exp.isEven ? sq : sq * base;
}

void main() {
  print(powerRecursive(2, 10)); // 1024
  print(powerRecursive(3, 5));  // 243
}
