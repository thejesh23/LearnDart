// Length of the longest strictly increasing subsequence. Patience sorting
// with binary search — O(n log n).
int longestIncreasingSubsequence(List<int> nums) {
  final tails = <int>[];
  for (final x in nums) {
    int lo = 0, hi = tails.length;
    while (lo < hi) {
      final mid = (lo + hi) ~/ 2;
      if (tails[mid] < x) {
        lo = mid + 1;
      } else {
        hi = mid;
      }
    }
    if (lo == tails.length) {
      tails.add(x);
    } else {
      tails[lo] = x;
    }
  }
  return tails.length;
}

void main() {
  print(longestIncreasingSubsequence([10, 9, 2, 5, 3, 7, 101, 18])); // 4
  print(longestIncreasingSubsequence([0, 1, 0, 3, 2, 3]));           // 4
  print(longestIncreasingSubsequence([7, 7, 7, 7]));                 // 1
}
