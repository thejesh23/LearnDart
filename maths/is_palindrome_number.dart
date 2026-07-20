// Palindrome number: 121, 1221, 7 are palindromes; 123, -121 (by
// convention) are not. The obvious way is to stringify and compare
// with the reverse — but you can do it in pure arithmetic:
//
//   Reverse half the digits and compare with the leading half.
//   n → n/10; rev = rev*10 + n%10 — until rev ≥ n.
//   The number is a palindrome iff n == rev (even digit count)
//                                 or n == rev/10 (odd digit count).
//
// Why *half*: reversing all the digits could overflow for huge n
// (in fixed-width int types). Only reversing half avoids the
// overflow entirely and also cuts the work in two.
//
// LeetCode #9. Compare with strings/is_palindrome.dart for the
// string-based variant.
bool isPalindromeNumber(int n) {
  if (n < 0) return false;
  if (n != 0 && n % 10 == 0) return false; // trailing zero can't match a nonzero leading digit
  int rev = 0;
  int x = n;
  while (x > rev) {
    rev = rev * 10 + x % 10;
    x ~/= 10;
  }
  return x == rev || x == rev ~/ 10;
}

void main() {
  print(isPalindromeNumber(0));      // true
  print(isPalindromeNumber(7));      // true
  print(isPalindromeNumber(121));    // true
  print(isPalindromeNumber(1221));   // true
  print(isPalindromeNumber(12321));  // true
  print(isPalindromeNumber(-121));   // false (convention)
  print(isPalindromeNumber(10));     // false
}
