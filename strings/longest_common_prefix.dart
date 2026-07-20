// Longest common prefix across an array of strings via vertical scanning.
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
