// Solve x ≡ r_i (mod m_i) for pairwise-coprime moduli using CRT.
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
