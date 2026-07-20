// Recursive Euclidean algorithm — the same math as maths/gcd.dart
// expressed as a single tail-shaped recursive call.
//
// The recursion depth is O(log min(a, b)) — very shallow even for
// large inputs, so stack overflow isn't a practical concern. Reads
// cleanly and matches how the algorithm is presented in every
// textbook: gcd(a, 0) = a; gcd(a, b) = gcd(b, a mod b).
int gcdRecursive(int a, int b) {
  a = a.abs(); b = b.abs();
  return b == 0 ? a : gcdRecursive(b, a % b);
}

void main() {
  print(gcdRecursive(48, 18));
  print(gcdRecursive(100, 75));
  print(gcdRecursive(17, 13));
}
