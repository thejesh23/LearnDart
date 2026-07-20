// Recursive binary search. Same halving strategy as the iterative
// version, but implemented as tail-shaped recursion where each call
// hands off a smaller [lo, hi] interval to itself.
//
// Dart does not guarantee tail-call optimization — every recursive
// call really does add a stack frame. On a list of 2^32 elements
// binary search takes ~32 comparisons, so stack depth is a non-issue,
// but if you're chasing raw speed the iterative form
// (searches/binary_search.dart) avoids the call overhead entirely.
//
// Included as a side-by-side teaching contrast: iterative shows how,
// recursive shows the invariant "the answer, if any, lies in
// sorted[lo..hi]" more explicitly. Complexity: O(log n).
int binarySearchRecursive(List<int> sorted, int target,
    [int? lo, int? hi]) {
  lo ??= 0;
  hi ??= sorted.length - 1;
  if (lo > hi) return -1;
  final mid = lo + (hi - lo) ~/ 2;
  if (sorted[mid] == target) return mid;
  if (sorted[mid] < target) {
    return binarySearchRecursive(sorted, target, mid + 1, hi);
  }
  return binarySearchRecursive(sorted, target, lo, mid - 1);
}

void main() {
  final data = [1, 3, 5, 7, 9, 11, 13];
  print(binarySearchRecursive(data, 7));
  print(binarySearchRecursive(data, 4));
}
