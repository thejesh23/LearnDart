// Two Sum: given an array of integers and a target, return whether
// any pair sums to the target. The naïve pairwise scan is O(n²) —
// this hash-map trick is O(n) time and O(n) space.
//
// The pattern: as you walk the array, ask "have I already seen the
// number I need to reach the target?" (that is, target − current).
// If yes, done. If no, record the current number and its index and
// keep going. Each element is visited once and each hash lookup is
// O(1) average.
//
// This is the canonical warm-up for the wider family of "complement
// search" problems: 3Sum, 4Sum, subarray-sum-equals-K, two-sum-of-a-
// sorted-array (which admits a slicker two-pointer O(n)-with-O(1)-
// space variant). LeetCode #1, and the interview question everybody
// has been asked at least once.
bool twoSum(List<int> nums, int target) {
  final seen = <int, int>{};
  for (int i = 0; i < nums.length; i++) {
    final complement = target - nums[i];
    if (seen.containsKey(complement)) return true;
    seen[nums[i]] = i;
  }
  return false;
}

List<int> twoSumIndices(List<int> nums, int target) {
  final seen = <int, int>{};
  for (int i = 0; i < nums.length; i++) {
    final complement = target - nums[i];
    if (seen.containsKey(complement)) return [seen[complement]!, i];
    seen[nums[i]] = i;
  }
  return const [];
}

void main() {
  print(twoSum([2, 7, 11, 15], 9));       // true
  print(twoSum([1, 2, 3, 4], 12));         // false
  print(twoSumIndices([3, 2, 4], 6));      // [1, 2]
  print(twoSumIndices([3, 3], 6));         // [0, 1]
}
