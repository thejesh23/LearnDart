// Modular inverse of `a` modulo `m` via the extended Euclidean algorithm.
// Requires gcd(a, m) == 1; returns null otherwise.
(int g, int x, int y) _extGcd(int a, int b) {
  if (b == 0) return (a, 1, 0);
  final (g, x1, y1) = _extGcd(b, a % b);
  return (g, y1, x1 - (a ~/ b) * y1);
}

int? modularInverse(int a, int m) {
  final (g, x, _) = _extGcd(a % m, m);
  if (g != 1) return null;
  return (x % m + m) % m;
}

void main() {
  print(modularInverse(3, 11));  // 4  (3*4 = 12 ≡ 1 mod 11)
  print(modularInverse(10, 17)); // 12
  print(modularInverse(6, 9));   // null (gcd != 1)
}
