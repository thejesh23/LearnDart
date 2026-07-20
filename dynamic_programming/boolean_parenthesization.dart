// Count the number of ways to parenthesize a boolean expression
// (symbols in T/F, operators in {&, |, ^}) so it evaluates to true.
int booleanParenthesization(String symbols, String operators) {
  final n = symbols.length;
  final t = List.generate(n, (_) => List<int>.filled(n, 0));
  final f = List.generate(n, (_) => List<int>.filled(n, 0));
  for (int i = 0; i < n; i++) {
    t[i][i] = symbols[i] == 'T' ? 1 : 0;
    f[i][i] = symbols[i] == 'F' ? 1 : 0;
  }
  for (int len = 2; len <= n; len++) {
    for (int i = 0; i + len - 1 < n; i++) {
      final j = i + len - 1;
      for (int k = i; k < j; k++) {
        final op = operators[k];
        final tik = t[i][k], fik = f[i][k];
        final tkj = t[k + 1][j], fkj = f[k + 1][j];
        if (op == '&') {
          t[i][j] += tik * tkj;
          f[i][j] += tik * fkj + fik * tkj + fik * fkj;
        } else if (op == '|') {
          t[i][j] += tik * tkj + tik * fkj + fik * tkj;
          f[i][j] += fik * fkj;
        } else {
          t[i][j] += tik * fkj + fik * tkj;
          f[i][j] += tik * tkj + fik * fkj;
        }
      }
    }
  }
  return t[0][n - 1];
}

void main() {
  print(booleanParenthesization('TTFT', '|&^'));  // 4
  print(booleanParenthesization('TFT',  '^&'));   // 2
}
