// Can `s` be segmented into a space-separated sequence of dictionary words?
// Backtracking with a visited set to avoid re-exploring the same prefix.
bool wordBreak(String s, Set<String> dict) {
  final failed = <int>{};
  bool helper(int start) {
    if (start == s.length) return true;
    if (failed.contains(start)) return false;
    for (int end = start + 1; end <= s.length; end++) {
      if (dict.contains(s.substring(start, end)) && helper(end)) {
        return true;
      }
    }
    failed.add(start);
    return false;
  }
  return helper(0);
}

void main() {
  print(wordBreak('leetcode', {'leet', 'code'}));         // true
  print(wordBreak('applepenapple', {'apple', 'pen'}));    // true
  print(wordBreak('catsandog', {'cats', 'dog', 'sand'})); // false
}
