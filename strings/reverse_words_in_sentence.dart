// Reverse the *order* of words in a sentence — "the sky is blue"
// becomes "blue is sky the". Characters within each word stay in
// order; runs of whitespace between words collapse to a single space.
//
// The one-liner uses split, reverse, join — clean and idiomatic in
// Dart. An O(1)-extra-space in-place version (common interview
// question): reverse the whole string, then reverse each word within
// the result. Two passes, no intermediate list.
//
// Complexity: O(n) time, O(n) space for the split output.
String reverseWords(String sentence) {
  return sentence
      .trim()
      .split(RegExp(r'\s+'))
      .reversed
      .join(' ');
}

void main() {
  print(reverseWords('the sky is blue'));         // 'blue is sky the'
  print(reverseWords('  hello   world  '));       // 'world hello'
  print(reverseWords('one'));                     // 'one'
}
