// Greatest common divisor via the Euclidean algorithm. The identity
// gcd(a, b) = gcd(b, a mod b) shrinks the pair rapidly: the second
// value halves at worst every two steps, giving O(log min(a, b)) work.
//
// One of the oldest algorithms still in daily use — Euclid described
// it around 300 BC. Foundation for modular arithmetic, fraction
// simplification, and cryptography. The Fibonacci pair (F_n, F_{n-1})
// is the *slowest* input, an accidental worst-case tie between two
// famous sequences.
//
// See maths/gcd_recursive.dart for the recursive form and
// number_theory/extended_euclidean.dart for the Bézout-coefficient
// variant used in modular inverse computations.
int gcd(int a, int b) {
  a = a.abs(); b = b.abs();
  while (b != 0) {
    final t = b;
    b = a % b;
    a = t;
  }
  return a;
}

void main() {
  print(gcd(48, 18));   // 6
  print(gcd(100, 75));  // 25
  print(gcd(17, 13));   // 1
}
