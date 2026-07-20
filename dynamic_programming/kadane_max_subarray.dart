// Kadane's algorithm — maximum-sum contiguous subarray in O(n)
// time, O(1) space. First published by Jay Kadane (Carnegie Mellon)
// in 1984, and immortalised in Jon Bentley's *Programming Pearls*
// as the elegant answer to a problem the brute force solves in
// O(n³).
//
// The DP intuition: define f(i) = max sum of a subarray *ending
// exactly at i*. Then f(i) = max(nums[i], f(i-1) + nums[i]) —
// either extend the previous best or start fresh at nums[i]. The
// answer is max over all f(i). Because f only depends on f(i-1),
// we only need one running variable, not an array.
//
// Edge case: an all-negative array. The classical Kadane returns
// the maximum (least-negative) element — not 0 as a "no subarray
// selected" interpretation. Handle whichever convention you need.
//
// Fun fact: Kadane's is the poster child for how a natural DP
// state definition ("... ending exactly at i") converts an O(n³)
// problem to O(n). LeetCode #53.
int maxSubarraySum(List<int> nums) {
  if (nums.isEmpty) throw ArgumentError('nums must be non-empty');
  int best = nums[0], current = nums[0];
  for (int i = 1; i < nums.length; i++) {
    current = current + nums[i] > nums[i] ? current + nums[i] : nums[i];
    if (current > best) best = current;
  }
  return best;
}

void main() {
  print(maxSubarraySum([-2, 1, -3, 4, -1, 2, 1, -5, 4])); // 6   ([4,-1,2,1])
  print(maxSubarraySum([1]));                              // 1
  print(maxSubarraySum([5, 4, -1, 7, 8]));                 // 23
  print(maxSubarraySum([-3, -1, -4, -2]));                 // -1
}
