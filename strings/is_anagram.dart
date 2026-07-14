// Case-insensitive, ignores whitespace.
bool isAnagram(String a, String b) {
  String norm(String s) {
    final chars = s.toLowerCase().replaceAll(' ', '').split('');
    chars.sort();
    return chars.join();
  }
  return norm(a) == norm(b);
}

void main() {
  print(isAnagram('listen', 'silent'));                  // true
  print(isAnagram('Astronomer', 'Moon starer'));         // true
  print(isAnagram('hello', 'world'));                    // false
}
