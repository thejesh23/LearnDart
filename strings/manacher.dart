// Manacher's algorithm: find the longest palindromic substring in
// O(n) — remarkable because the naive "expand around each center"
// approach is O(n^2).
//
// The setup trick: insert a '#' between every character (and at both
// ends), plus distinct sentinels '^' and '$' outside. Every palindrome
// in the original string, odd or even length, becomes an odd-length
// palindrome in the transformed string centered at some position, so
// one code path handles both cases.
//
// The linear-time achievement comes from reusing work: maintain the
// rightmost palindrome seen so far, and when computing a new position
// inside it, use its mirror's palindrome radius as a starting lower
// bound before extending. Each character extension moves the boundary
// forward by 1, so total work is O(n) amortized.
String longestPalindrome(String s) {
  if (s.isEmpty) return '';
  final t = '^#${s.split('').join('#')}#\$';
  final n = t.length;
  final p = List<int>.filled(n, 0);
  int c = 0, r = 0;
  for (int i = 1; i < n - 1; i++) {
    final mirror = 2 * c - i;
    if (i < r) p[i] = (r - i) < p[mirror] ? (r - i) : p[mirror];
    while (t[i + 1 + p[i]] == t[i - 1 - p[i]]) p[i]++;
    if (i + p[i] > r) { c = i; r = i + p[i]; }
  }
  int maxLen = 0, centerIndex = 0;
  for (int i = 1; i < n - 1; i++) {
    if (p[i] > maxLen) { maxLen = p[i]; centerIndex = i; }
  }
  final start = (centerIndex - maxLen) ~/ 2;
  return s.substring(start, start + maxLen);
}

void main() {
  print(longestPalindrome('babad'));                  // 'bab' or 'aba'
  print(longestPalindrome('cbbd'));                   // 'bb'
  print(longestPalindrome('forgeeksskeegfor'));       // 'geeksskeeg'
}
