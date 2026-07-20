// Validate Subsequence: is `sequence` obtainable from `array` by
// deleting zero or more elements while keeping the remaining ones
// in their original order? "abc" is a subsequence of "aXbYcZ"; it
// is *not* a substring (contiguity is not required).
//
// One walk with two pointers does it in O(n) time and O(1) space:
// one pointer scans the array, the other tracks how much of the
// sequence has been matched. Every time the current array element
// equals the current sequence element, advance the sequence
// pointer. If it reaches the end, all of `sequence` was matched.
//
// Fundamental primitive underlying: longest-common-subsequence
// (which counts, rather than tests), diff/patch tools, DNA-sequence
// matching, and any "is A embedded in B" check.
bool isSubsequence(List<int> array, List<int> sequence) {
  if (sequence.isEmpty) return true;
  int j = 0;
  for (int i = 0; i < array.length && j < sequence.length; i++) {
    if (array[i] == sequence[j]) j++;
  }
  return j == sequence.length;
}

void main() {
  print(isSubsequence([5, 1, 22, 25, 6, -1, 8, 10], [1, 6, -1, 10])); // true
  print(isSubsequence([5, 1, 22, 25, 6, -1, 8, 10], [1, 6, 10, -1])); // false
  print(isSubsequence([1, 2, 3], []));                                  // true
  print(isSubsequence([], [1]));                                        // false
}
