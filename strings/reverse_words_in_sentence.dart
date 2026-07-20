// Reverse the order of words in a sentence, collapsing runs of whitespace
// into a single space. Characters within each word stay in order.
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
