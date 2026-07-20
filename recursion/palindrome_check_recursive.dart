// Palindrome check by comparing the ends of the string and recursing
// on the middle. Base cases: empty or single-character strings are
// palindromes; if the two ends differ, the string is not.
//
// Same O(n) *comparison* work as the iterative two-pointer variant in
// strings/is_palindrome.dart, but with O(n^2) allocation overhead
// because `substring(1, n-1)` copies memory each call. Included as a
// small, side-by-side contrast with the iterative form so learners can
// see the same algorithm expressed two ways.
//
// Recursion depth is n/2 — no stack-overflow risk for reasonable inputs.
bool isPalindromeRecursive(String s) {
  final n = s.length;
  if (n <= 1) return true;
  if (s[0] != s[n - 1]) return false;
  return isPalindromeRecursive(s.substring(1, n - 1));
}

void main() {
  for (final s in ['racecar', 'hello', 'noon', 'a', '']) {
    print('"$s" -> ${isPalindromeRecursive(s)}');
  }
}
