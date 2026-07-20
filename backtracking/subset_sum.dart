// Enumerate every subset of `nums` that sums to `target`.
//
// The recursion is the same binary "include-or-skip" shape as
// recursion/subset_generation.dart, but we prune branches that can't
// possibly reach the target (`remaining < 0`) or that have run out of
// elements. This class of problem is NP-hard in general — you can't
// hope for polynomial-time enumeration when the number of solutions
// itself can be exponential.
//
// For the *decision* version ("is there any subset that sums to
// target?") the pseudo-polynomial DP in
// dynamic_programming/partition_equal_subset_sum.dart is much faster
// when the target is small. Complexity: O(2^n) worst case here.
List<List<int>> subsetsSummingTo(List<int> nums, int target) {
  final results = <List<int>>[];
  final current = <int>[];

  void choose(int i, int remaining) {
    if (remaining == 0) {
      results.add(List<int>.of(current));
      return;
    }
    if (i == nums.length || remaining < 0) return;
    // include nums[i]
    current.add(nums[i]);
    choose(i + 1, remaining - nums[i]);
    current.removeLast();
    // skip nums[i]
    choose(i + 1, remaining);
  }

  choose(0, target);
  return results;
}

void main() {
  print(subsetsSummingTo([2, 3, 5, 7], 10));
  print(subsetsSummingTo([1, 1, 2, 3], 3));
}
