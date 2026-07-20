// Find a peak element in an array — an index i such that
// arr[i-1] < arr[i] > arr[i+1] (treating out-of-bounds as -∞). If
// there are multiple peaks, any one is acceptable.
//
// The naïve linear scan is O(n). The surprise: even though the
// array is *not* sorted, binary search finds a peak in O(log n).
// Why? At each midpoint m, look at arr[m] vs arr[m+1]:
//   - If arr[m] > arr[m+1], the left half (including m) must
//     contain a peak — arr[m] is at least a local max relative to
//     m+1, and even if it slopes down further, the leftmost element
//     is bounded by -∞.
//   - Otherwise, the right half contains a peak by the mirror
//     argument.
// So we halve the range each step. This is the canonical example
// of "binary search doesn't require sorted-ness, only monotone
// discriminant". LeetCode #162.
int findPeakElement(List<int> arr) {
  int lo = 0, hi = arr.length - 1;
  while (lo < hi) {
    final mid = lo + (hi - lo) ~/ 2;
    if (arr[mid] > arr[mid + 1]) {
      hi = mid;
    } else {
      lo = mid + 1;
    }
  }
  return lo;
}

void main() {
  print(findPeakElement([1, 2, 3, 1]));           // 2   (arr[2]=3 is the peak)
  print(findPeakElement([1, 2, 1, 3, 5, 6, 4]));  // 1 or 5
  print(findPeakElement([1]));                     // 0
  print(findPeakElement([1, 2]));                  // 1
  print(findPeakElement([2, 1]));                  // 0
}
