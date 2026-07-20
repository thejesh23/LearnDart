// Least common multiple of two integers via the identity
// lcm(a, b) = |a · b| / gcd(a, b).
//
// The `(a / gcd) * b` order rather than `a * b / gcd` matters: with
// large operands, `a * b` might overflow before the division brings
// it back into range. Dividing first keeps the intermediate value
// smaller.
//
// Edge case: lcm(0, x) is conventionally 0 (nothing is a multiple
// of 0 except 0). Complexity: dominated by the gcd call, O(log min).

int _gcd(int a, int b) {
  a = a.abs(); b = b.abs();
  while (b != 0) { final t = b; b = a % b; a = t; }
  return a;
}

int lcm(int a, int b) {
  if (a == 0 || b == 0) return 0;
  return (a ~/ _gcd(a, b)) * b;
}

void main() {
  print(lcm(4, 6));   // 12
  print(lcm(21, 6));  // 42
  print(lcm(0, 5));   // 0
}
