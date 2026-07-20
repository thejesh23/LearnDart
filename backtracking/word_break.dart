// Can `s` be segmented into a sequence of dictionary words? For each
// prefix of `s`, if the prefix is in the dictionary, recurse on the
// remainder.
//
// Naive backtracking would revisit the same suffix many times over
// (different prefixes can lead to the same starting index). The
// `failed` set is memoization for the *negative* answers: once we've
// proven no segmentation starts at index i, remember it and short-
// circuit any future call. This turns exponential worst-case work into
// O(n^2) — essentially a top-down variant of the DP solution.
//
// Complexity: O(n^2 · maxWordLength) once memoized. Related:
// dynamic_programming/palindrome_partitioning.dart uses the same
// prefix-DP shape for a related segmentation problem.
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
