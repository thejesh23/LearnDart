// The nth Catalan number counts balanced-parentheses strings of length 2n,
// binary trees with n nodes, and much more. C(n) = sum_{i=0..n-1} C(i)*C(n-1-i).
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
