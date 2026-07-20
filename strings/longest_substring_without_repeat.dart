// Length of the longest substring of `s` with no repeated characters.
// Sliding window with a last-index map — O(n).
int longestUniqueSubstring(String s) {
  final lastSeen = <String, int>{};
  int start = 0, best = 0;
  for (int i = 0; i < s.length; i++) {
    final ch = s[i];
    final prev = lastSeen[ch];
    if (prev != null && prev >= start) {
      start = prev + 1;
    }
    lastSeen[ch] = i;
    if (i - start + 1 > best) best = i - start + 1;
  }
  return best;
}

void main() {
  print(longestUniqueSubstring('abcabcbb'));  // 3  ("abc")
  print(longestUniqueSubstring('bbbbb'));     // 1
  print(longestUniqueSubstring('pwwkew'));    // 3  ("wke")
  print(longestUniqueSubstring(''));          // 0
}
