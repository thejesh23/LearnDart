// Longest common prefix across a list of strings — the longest string
// that is a prefix of every input. If any input is empty, or the first
// characters diverge, the result is ''.
//
// Vertical scan: at each position i, check whether every input has the
// same character. Stop at the first mismatch. Alternatives include
// sorting the list and comparing only the first and last strings, or
// building a trie (data_structures/trie.dart) if you'll query the
// same set of strings many times.
//
// Complexity: O(S) where S is the sum of the lengths of all strings —
// each character is compared at most once. O(1) extra space.
String longestCommonPrefix(List<String> strs) {
  if (strs.isEmpty) return '';
  for (int i = 0; i < strs[0].length; i++) {
    final ch = strs[0][i];
    for (int j = 1; j < strs.length; j++) {
      if (i >= strs[j].length || strs[j][i] != ch) {
        return strs[0].substring(0, i);
      }
    }
  }
  return strs[0];
}

void main() {
  print(longestCommonPrefix(['flower', 'flow', 'flight'])); // 'fl'
  print(longestCommonPrefix(['dog', 'racecar', 'car']));    // ''
  print(longestCommonPrefix(['interspecies', 'interstellar', 'interstate'])); // 'inters'
}
