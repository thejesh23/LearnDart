// Pivot Index: find the smallest index i such that the sum of the
// elements strictly to its left equals the sum strictly to its
// right. Return -1 if no such index exists.
//
// The brute-force computes leftSum + rightSum at each i in O(n²).
// The prefix-sum trick makes it O(n): compute the total once, then
// walk left-to-right maintaining a running leftSum; the rightSum
// at index i is `total - leftSum - nums[i]`.
//
// This is a canonical prefix-sum warm-up; the same trick underlies
// "product of array except self", "range sum queries", and "count
// subarrays summing to K". LeetCode #724.
int pivotIndex(List<int> nums) {
  int total = 0;
  for (final v in nums) total += v;
  int leftSum = 0;
  for (int i = 0; i < nums.length; i++) {
    if (leftSum == total - leftSum - nums[i]) return i;
    leftSum += nums[i];
  }
  return -1;
}

void main() {
  print(pivotIndex([1, 7, 3, 6, 5, 6])); // 3   (left 1+7+3=11, right 5+6=11)
  print(pivotIndex([1, 2, 3]));           // -1
  print(pivotIndex([2, 1, -1]));          // 0   (empty left, right 1+(-1)=0)
}
