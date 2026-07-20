// Chinese Remainder Theorem: given the residues of x modulo several
// pairwise-coprime moduli, recover x modulo their product.
//
// Concretely, if x ≡ r_1 (mod m_1), r_2 (mod m_2), ..., r_k (mod m_k),
// and the m_i are pairwise coprime, there's a unique solution mod
// M = m_1 · m_2 · ... · m_k. Compute it via a weighted sum of the
// residues, where each weight is (M / m_i) · inverse(M / m_i, m_i).
//
// Returns null if the moduli are not pairwise coprime (the general CRT
// exists but needs the residues themselves to be compatible). Uses
// extended Euclidean (extended_euclidean.dart) to find the inverses.
//
// Applications: RSA speedup (using p and q separately then combining),
// hash tables with several buckets, secret sharing, ancient calendar
// alignment problems. Complexity: O(k · log M).
(int g, int x, int y) _extGcd(int a, int b) {
  if (b == 0) return (a, 1, 0);
  final (g, x1, y1) = _extGcd(b, a % b);
  return (g, y1, x1 - (a ~/ b) * y1);
}

int? chineseRemainder(List<int> remainders, List<int> moduli) {
  int M = 1;
  for (final m in moduli) M *= m;
  int x = 0;
  for (int i = 0; i < moduli.length; i++) {
    final Mi = M ~/ moduli[i];
    final (g, inv, _) = _extGcd(Mi, moduli[i]);
    if (g != 1) return null; // moduli not coprime
    x = (x + remainders[i] * Mi * inv) % M;
  }
  return (x % M + M) % M;
}

void main() {
  print(chineseRemainder([2, 3, 2], [3, 5, 7])); // 23
  print(chineseRemainder([0, 3, 4], [3, 4, 5])); // 39
}
