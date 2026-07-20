// Catalan numbers C(n): a sequence 1, 1, 2, 5, 14, 42, 132, 429, ...
// that counts an astonishing number of combinatorial objects:
//   - Balanced-parenthesis strings of length 2n
//   - Binary trees with n internal nodes
//   - Triangulations of a convex (n+2)-gon
//   - Dyck paths of length 2n
//   - Non-crossing chord diagrams on 2n points on a circle
//
// Recurrence: C(n) = sum_{i=0..n-1} C(i) · C(n-1-i). Every one of the
// listed structures has a natural "split" whose recursion gives
// exactly this sum.
//
// Closed form: C(n) = (1 / (n+1)) · C(2n, n) — see
// maths/binomial_coefficient.dart. Complexity here: O(n^2) with BigInt
// multiplications.
List<BigInt> catalanNumbers(int upTo) {
  final c = List<BigInt>.filled(upTo + 1, BigInt.zero);
  c[0] = BigInt.one;
  for (int n = 1; n <= upTo; n++) {
    for (int i = 0; i < n; i++) {
      c[n] += c[i] * c[n - 1 - i];
    }
  }
  return c;
}

void main() {
  final catalans = catalanNumbers(15);
  for (int i = 0; i < catalans.length; i++) {
    print('C($i) = ${catalans[i]}');
  }
}
