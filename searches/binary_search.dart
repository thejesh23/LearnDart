// Iterative binary search on a sorted list. Halve the search interval
// each iteration until you find the target or the interval is empty.
//
// One of the smallest algorithms in the book and one of the buggiest —
// according to Jon Bentley, "the first published binary search in 1946
// contained a bug that persisted in libraries for 20 years." The two
// classic pitfalls: (1) integer overflow in the midpoint calculation
// (fixed here by writing `lo + (hi - lo) ~/ 2` rather than `(lo + hi) ~/ 2`),
// and (2) off-by-one errors on the loop bound and update rules.
//
// Precondition: input is sorted ascending. Complexity: O(log n) time,
// O(1) space. See binary_search_recursive.dart for the recursive variant
// and searches/exponential_search.dart for unbounded arrays.
int binarySearch(List<int> sorted, int target) {
  int lo = 0;
  int hi = sorted.length - 1;
  while (lo <= hi) {
    final mid = lo + (hi - lo) ~/ 2;
    if (sorted[mid] == target) return mid;
    if (sorted[mid] < target) {
      lo = mid + 1;
    } else {
      hi = mid - 1;
    }
  }
  return -1;
}

void main() {
  final data = [1, 3, 5, 7, 9, 11, 13];
  print(binarySearch(data, 7));  // 3
  print(binarySearch(data, 4));  // -1
}
