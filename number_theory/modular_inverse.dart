// Modular inverse: given a and m with gcd(a, m) = 1, find x in [0, m)
// such that a · x ≡ 1 (mod m). Returns null when gcd(a, m) ≠ 1 — no
// inverse exists in that case.
//
// Extended Euclidean (extended_euclidean.dart) gives x and y with
// a · x + m · y = gcd(a, m). When the gcd is 1, reducing x mod m
// makes it the modular inverse directly. The `(x % m + m) % m`
// dance normalizes the result into [0, m), since Dart's `%` can
// return a negative value when x is negative.
//
// When m is prime, Fermat's little theorem gives another route:
// a^(m-2) mod m is the inverse. Extended-gcd works for any m; the
// Fermat trick only works for prime m but avoids the recursion.
// Complexity: O(log min(a, m)).
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
