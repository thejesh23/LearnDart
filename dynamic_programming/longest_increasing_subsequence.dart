// Longest Increasing Subsequence (LIS): length of the longest
// strictly increasing subsequence of the input array.
//
// Two standard approaches:
//   1. Straightforward O(n^2) DP: dp[i] = 1 + max(dp[j]) for j < i
//      with nums[j] < nums[i].
//   2. This "patience sorting" trick: for each element, binary-search
//      into a `tails` list where tails[k] is the smallest tail of any
//      length-(k+1) increasing subsequence seen so far. Length of
//      tails at the end is the LIS length. O(n log n).
//
// Note: `tails` is not itself a valid subsequence — it holds the best
// achievable tail at each length. Recovering an actual LIS needs an
// extra parent-pointer array.
//
// Applications: box-stacking, longest chain of dependent tasks,
// activity selection variants. Complexity: O(n log n).
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
