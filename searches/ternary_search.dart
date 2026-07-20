// Ternary search on a sorted list: split the range into thirds at every
// step instead of halves. Each iteration checks two probe positions
// (m1, m2) and shrinks the range to one of three sub-intervals.
//
// It's a common misconception that dividing by 3 makes ternary search
// faster than binary search. It doesn't: binary search does 1
// comparison per log2(n) steps ~= log2(n) total; ternary does 2
// comparisons per log3(n) steps ~= 2 · log3(n) = ~1.26 · log2(n) total.
// Ternary loses on element comparisons.
//
// Where ternary really *is* useful: finding the maximum/minimum of a
// unimodal function (one hill or one valley), where you compare
// f(m1) with f(m2) rather than with a target value.
//
// Complexity: O(log n) time. See ternary_search_recursive.dart for the
// recursive variant.
int ternarySearch(List<int> sorted, int target) {
  int lo = 0;
  int hi = sorted.length - 1;
  while (lo <= hi) {
    final third = (hi - lo) ~/ 3;
    final m1 = lo + third;
    final m2 = hi - third;
    if (sorted[m1] == target) return m1;
    if (sorted[m2] == target) return m2;
    if (target < sorted[m1]) {
      hi = m1 - 1;
    } else if (target > sorted[m2]) {
      lo = m2 + 1;
    } else {
      lo = m1 + 1;
      hi = m2 - 1;
    }
  }
  return -1;
}

void main() {
  final data = [1, 3, 5, 7, 9, 11, 13, 15, 17];
  print(ternarySearch(data, 11));
  print(ternarySearch(data, 4));
}
