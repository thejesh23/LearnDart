// Given non-negative amounts stashed in a row of houses, find the maximum
// you can rob without touching two adjacent houses. Rolling two variables
// gives O(n) time, O(1) space.
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
