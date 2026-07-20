// Minimum cuts to partition a string into palindromes.
int minPalindromeCuts(String s) {
  final n = s.length;
  if (n < 2) return 0;
  final isPal = List.generate(n, (_) => List<bool>.filled(n, false));
  for (int i = 0; i < n; i++) isPal[i][i] = true;
  for (int len = 2; len <= n; len++) {
    for (int i = 0; i + len - 1 < n; i++) {
      final j = i + len - 1;
      if (s[i] == s[j] && (len == 2 || isPal[i + 1][j - 1])) {
        isPal[i][j] = true;
      }
    }
  }
  final cuts = List<int>.filled(n, 0);
  for (int i = 0; i < n; i++) {
    if (isPal[0][i]) {
      cuts[i] = 0;
      continue;
    }
    cuts[i] = i;
    for (int j = 1; j <= i; j++) {
      if (isPal[j][i] && cuts[j - 1] + 1 < cuts[i]) {
        cuts[i] = cuts[j - 1] + 1;
      }
    }
  }
  return cuts[n - 1];
}

void main() {
  print(minPalindromeCuts('aab'));     // 1
  print(minPalindromeCuts('abcbm'));   // 2
  print(minPalindromeCuts('noonabbad')); // 2
}
