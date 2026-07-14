// Case-insensitive, ignores non-alphanumeric characters.
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
