// Maximum sum of a subset of an array where no two chosen elements
// are adjacent. Framed as "houses on a street with alarms triggered
// by robbing neighbors", but the abstraction is what matters.
//
// DP recurrence: rob[i] = max(rob[i-2] + nums[i], rob[i-1]) — either
// take this house (plus best two back) or skip it. Only the two most
// recent values are ever needed, so we use two scalar variables
// instead of an array — O(1) space.
//
// Variants: "House Robber II" arranges houses in a circle (first and
// last are adjacent — run twice, excluding one endpoint each time).
// "Delete and Earn" reduces to this by pre-processing.
//
// Complexity: O(n) time, O(1) space.
int houseRobber(List<int> nums) {
  int prev2 = 0, prev1 = 0;
  for (final v in nums) {
    final take = prev2 + v;
    final skip = prev1;
    final now = take > skip ? take : skip;
    prev2 = prev1;
    prev1 = now;
  }
  return prev1;
}

void main() {
  print(houseRobber([1, 2, 3, 1]));      // 4
  print(houseRobber([2, 7, 9, 3, 1]));   // 12
  print(houseRobber([2, 1, 1, 2]));      // 4
}
