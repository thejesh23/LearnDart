// Anagram test: do two strings contain the exact same multiset of
// characters? Normalize (lowercase, remove spaces), sort each string's
// characters, and compare.
//
// The sort-and-compare approach is O(n log n). An O(n) alternative
// uses a character-frequency map (see strings/character_frequency.dart):
// count each string's characters and compare the two maps. That's
// asymptotically better but has larger constant factors — sort wins
// for short strings.
//
// Complexity: O(n log n) time, O(n) space.
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
