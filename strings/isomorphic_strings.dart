// Isomorphic strings: two strings s and t are *isomorphic* iff
// there is a bijection between the characters of s and t that
// preserves order. "egg" ↔ "add" is isomorphic (e→a, g→d). "foo"
// ↔ "bar" is not (both o's would need to map to different chars).
//
// The trick: maintain *two* maps — s→t and t→s — and reject any
// input that would break either direction. A single map is not
// enough because it wouldn't catch two source chars mapping to
// the same target char (which violates injectivity).
//
// Complexity: O(n) time, O(k) space where k = alphabet size.
// LeetCode #205. Related to strings/is_anagram.dart, but on
// character *mappings* rather than multiset equality.
bool isIsomorphic(String s, String t) {
  if (s.length != t.length) return false;
  final sToT = <int, int>{};
  final tToS = <int, int>{};
  for (int i = 0; i < s.length; i++) {
    final a = s.codeUnitAt(i), b = t.codeUnitAt(i);
    final ea = sToT[a], eb = tToS[b];
    if (ea == null && eb == null) {
      sToT[a] = b;
      tToS[b] = a;
    } else if (ea != b || eb != a) {
      return false;
    }
  }
  return true;
}

void main() {
  print(isIsomorphic('egg', 'add'));     // true
  print(isIsomorphic('foo', 'bar'));     // false  (o→a and o→r conflict)
  print(isIsomorphic('paper', 'title')); // true
  print(isIsomorphic('ab', 'aa'));       // false  (a and b both →a)
}
