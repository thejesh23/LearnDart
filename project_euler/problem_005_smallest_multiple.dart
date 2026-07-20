// Project Euler #5 — Smallest multiple.
// https://projecteuler.net/problem=5
//
// "What is the smallest positive number that is evenly divisible
//  by all of the numbers from 1 to 20?"
//
// This is asking for lcm(1, 2, ..., n). The brute "keep adding
// until it divides evenly by all" works but is astronomically
// slow. Instead, fold the pairwise lcm:
//
//   lcm(a, b) = a * b / gcd(a, b)
//
// Do that reducing across 1..n and you're done in n gcd
// computations, each O(log max). For n = 20 the answer is
// 232792560 — a 9-digit number the brute force would grind
// through hundreds of millions of candidates to reach.
//
// The lcm/gcd identity is the same one exercised in
// maths/lcm.dart and maths/gcd.dart.
int _gcd(int a, int b) { while (b != 0) { final t = b; b = a % b; a = t; } return a; }
int _lcm(int a, int b) => (a ~/ _gcd(a, b)) * b;

int smallestMultiple(int n) {
  int result = 1;
  for (int i = 2; i <= n; i++) result = _lcm(result, i);
  return result;
}

void main() {
  print(smallestMultiple(10)); // 2520
  print(smallestMultiple(20)); // 232792560 (the Project Euler answer)
}
