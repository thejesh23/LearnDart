// Palindrome test: does the string read the same forwards and
// backwards? Two-pointer scan from both ends inward, stopping when
// they meet.
//
// This version *normalizes* the input first: lowercase everything and
// strip punctuation/whitespace, so "A man, a plan, a canal: Panama"
// counts as a palindrome. That normalization is a design choice —
// strict palindrome tests keep every character. Adjust to taste.
//
// Complexity: O(n) time, O(n) space (for the normalized copy). See
// recursion/palindrome_check_recursive.dart for the recursive variant
// and dynamic_programming/longest_palindromic_subsequence.dart for
// the LPS problem.
bool isPalindrome(String s) {
  final normalized = s.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');
  int i = 0, j = normalized.length - 1;
  while (i < j) {
    if (normalized[i] != normalized[j]) return false;
    i++; j--;
  }
  return true;
}

void main() {
  for (final s in ['racecar', 'hello', 'A man, a plan, a canal: Panama', '12321']) {
    print('"$s" -> ${isPalindrome(s)}');
  }
}
