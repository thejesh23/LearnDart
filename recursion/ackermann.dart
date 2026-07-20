// The Ackermann function — the poster child for
// "computable but not primitive-recursive". Defined by:
//
//   A(0, n) = n + 1
//   A(m, 0) = A(m − 1, 1)                     for m > 0
//   A(m, n) = A(m − 1, A(m, n − 1))           for m, n > 0
//
// It looks harmless, but blows up faster than any function you can
// write with bounded for-loops. For fixed m:
//   A(1, n) = n + 2
//   A(2, n) = 2n + 3
//   A(3, n) = 2^(n+3) − 3
//   A(4, n) = 2^(2^(...^2)) − 3   (a tower of n+3 twos)
// A(4, 2) already has 19729 digits. A(4, 3) needs the whole
// observable universe worth of atoms to write down.
//
// Why care? Ackermann is the standard counter-example that shows
// primitive recursion (bounded loops only) is strictly weaker than
// general recursion. And its inverse α(n) is the tightest bound
// on operations in union-find with path compression + union by
// rank (see data_structures/disjoint_set.dart) — α grows so slowly
// that it's ≤ 4 for any n we can ever physically write down.
//
// This straightforward Dart recursion blows the call stack on
// even modest inputs; A(3, 6) or A(3, 7) is roughly the ceiling.
int ackermann(int m, int n) {
  if (m == 0) return n + 1;
  if (n == 0) return ackermann(m - 1, 1);
  return ackermann(m - 1, ackermann(m, n - 1));
}

void main() {
  for (int m = 0; m < 4; m++) {
    for (int n = 0; n < 4; n++) {
      print('A($m, $n) = ${ackermann(m, n)}');
    }
  }
  // A(3, 6) = 509; A(3, 7) = 1021 — anything past that will stack-overflow.
}
