// Counting sort: a non-comparison sort. For each possible value, count
// how many times it appears, then reconstruct the sorted output from
// the counts.
//
// Beats the comparison-sort lower bound of Ω(n log n) — but only for
// integer keys drawn from a small, bounded range k. Complexity is
// O(n + k), which is linear in n only when k is O(n). For 64-bit
// integers with an unrestricted range you'd allocate a 2^64-slot
// count array, which is impossible.
//
// The stable variant (using a prefix-sum "positions" array) is the
// subroutine inside radix sort — see sorts/radix_sort.dart, which
// runs counting sort digit by digit to handle unbounded integer keys
// in O(d · n) total. Complexity here: O(n + k), stable.
List<int> countingSort(List<int> input) {
  if (input.isEmpty) return [];
  final min = input.reduce((a, b) => a < b ? a : b);
  final max = input.reduce((a, b) => a > b ? a : b);
  final counts = List<int>.filled(max - min + 1, 0);
  for (final v in input) counts[v - min]++;
  final out = <int>[];
  for (int i = 0; i < counts.length; i++) {
    for (int k = 0; k < counts[i]; k++) out.add(i + min);
  }
  return out;
}

void main() {
  print(countingSort([4, 2, 2, 8, 3, 3, 1]));
  print(countingSort([-2, 0, -1, 3, 1]));
}
