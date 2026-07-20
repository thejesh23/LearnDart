// Factorial n! = n · (n-1) · ... · 2 · 1.
//
// Grows *fast*: 20! already exceeds the max 63-bit signed int, so we
// use `BigInt` for correct results at any n. Practically, this iterative
// form is only outrun by more elaborate schemes at very large n
// (thousands of digits), where prime-swing factorization or split-
// binary recursion cuts the multiplication cost.
//
// Applications everywhere: permutations count P(n, r) = n!/(n-r)!,
// combinations count C(n, r) = n!/(r!(n-r)!) — see
// maths/binomial_coefficient.dart, series expansions in analysis,
// probability distributions. Complexity: O(n) big-int multiplications.

BigInt factorial(int n) {
  if (n < 0) throw ArgumentError('n must be non-negative');
  var result = BigInt.one;
  for (int i = 2; i <= n; i++) {
    result *= BigInt.from(i);
  }
  return result;
}

void main() {
  for (final n in [0, 1, 5, 10, 25]) {
    print('$n! = ${factorial(n)}');
  }
}
