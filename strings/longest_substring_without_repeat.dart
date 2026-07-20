// Length of the longest substring of `s` with no repeated characters.
//
// Sliding-window technique: `start` is the left boundary; `i` is the
// right boundary; grow the window by advancing `i`, and shrink it
// (bump `start`) whenever the character at `i` was already seen
// inside the current window. The lastSeen map lets that shrink step
// jump directly to the position after the previous occurrence
// rather than dropping one character at a time.
//
// Each character is visited at most twice (once as new right,
// possibly once when start jumps past it), so total work is O(n).
// The template — two indices, a "seen" map, and a monotonically
// advancing right end — recurs across "longest window satisfying
// X" problems. Complexity: O(n) time, O(alphabet) space.
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
