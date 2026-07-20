// Palindrome check by comparing the ends and recursing on the middle.
// The iterative two-pointer variant lives in strings/is_palindrome.dart.
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
