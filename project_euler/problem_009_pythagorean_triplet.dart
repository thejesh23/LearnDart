// Project Euler #9 — Special Pythagorean triplet.
// https://projecteuler.net/problem=9
//
// "There exists exactly one Pythagorean triplet (a, b, c) with
//  a < b < c, a + b + c = 1000. Find the product abc."
//
// The brute triple loop is O(n³). The double loop is enough
// (given a and b, c = 1000 − a − b is forced) and runs in O(n²).
// But there's an even slicker O(n) using Euclid's parametrisation:
// every primitive triple is (m² − k², 2mk, m² + k²) for coprime
// m > k with opposite parity. Sum = 2m(m + k). So we need
// 2m(m + k) | perimeter, and can iterate m and k directly.
//
// Here we present the O(n²) form because it's the honest, direct
// translation of "a + b + c = perimeter and a² + b² = c²".
List<int> findPythagoreanTriplet(int perimeter) {
  for (int a = 1; a < perimeter ~/ 3; a++) {
    for (int b = a + 1; b < (perimeter - a) ~/ 2; b++) {
      final c = perimeter - a - b;
      if (a * a + b * b == c * c) return [a, b, c];
    }
  }
  return const [];
}

void main() {
  final t = findPythagoreanTriplet(1000);
  print(t);                                 // [200, 375, 425]
  print(t[0] * t[1] * t[2]);                // 31875000 (the Euler answer)
}
