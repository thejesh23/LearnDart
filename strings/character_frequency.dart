// Return a map from character to occurrence count.
//
// Building block for many algorithms: anagram checks (compare two
// frequency maps), palindrome permutation tests (at most one odd
// count), Huffman encoding (feeds the frequency table into
// greedy/huffman_encoding.dart), the "count characters" step of
// Rabin-Karp windows, and rolling-window unique-character tracking.
//
// Iterates code units, so multi-byte graphemes are counted per
// component — see strings/reverse_string.dart for the same caveat.
// Complexity: O(n) time, O(k) space where k is the alphabet size.

Map<String, int> characterFrequency(String s) {
  final counts = <String, int>{};
  for (final ch in s.split('')) {
    counts[ch] = (counts[ch] ?? 0) + 1;
  }
  return counts;
}

void main() {
  final freq = characterFrequency('mississippi');
  print(freq); // {m: 1, i: 4, s: 4, p: 2}
}
