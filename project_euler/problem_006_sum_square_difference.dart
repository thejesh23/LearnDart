// Project Euler #6 — Sum square difference.
// https://projecteuler.net/problem=6
//
// "Find the difference between the sum of the squares of the first
//  one hundred natural numbers and the square of the sum."
//
// Both quantities have famous closed forms (Gauss's identities):
//
//   Σ i        =  n(n+1)/2
//   Σ i²       =  n(n+1)(2n+1)/6
//
// So (Σ i)² − Σ i² is O(1) arithmetic — no loop needed. For n=100
// that's 25502500 − 338350 = 25164150.
//
// This is the pedagogical example of "prefer a closed form over
// a loop when one exists" — the same idea underlies triangular
// numbers, arithmetic series, and the many Project-Euler problems
// that hinge on recognising a summation identity.
int sumSquareDifference(int n) {
  final sum = n * (n + 1) ~/ 2;
  final sumOfSquares = n * (n + 1) * (2 * n + 1) ~/ 6;
  return sum * sum - sumOfSquares;
}

void main() {
  print(sumSquareDifference(10));  // 2640
  print(sumSquareDifference(100)); // 25164150 (the Project Euler answer)
}
