// Iterative Euclidean algorithm.
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
