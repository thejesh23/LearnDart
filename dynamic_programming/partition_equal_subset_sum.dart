// Partition a set of positive integers into two subsets with equal
// sum? Reduces to subset-sum: reachable[target] where target = sum/2.
//
// DP state: reachable[s] = "is there a subset summing to s?" Update
// each element by iterating *backwards* — that's what turns the naive
// 2-D DP into 1-D. Going backwards ensures each element is used at
// most once (0/1 semantics); forwards would allow unlimited reuse
// (unbounded knapsack).
//
// Same core as 0/1 knapsack, boolean-valued instead of numerical.
// Solved in O(n · sum) — pseudo-polynomial, so tractable when the
// total is small (up to ~10^5 or so).
//
// Complexity: O(n · sum) time, O(sum) space.
bool canPartition(List<int> nums) {
  final total = nums.fold<int>(0, (a, b) => a + b);
  if (total.isOdd) return false;
  final target = total ~/ 2;
  final reachable = List<bool>.filled(target + 1, false);
  reachable[0] = true;
  for (final n in nums) {
    for (int s = target; s >= n; s--) {
      if (reachable[s - n]) reachable[s] = true;
    }
  }
  return reachable[target];
}

void main() {
  print(canPartition([1, 5, 11, 5]));  // true  (1+5+5 = 11)
  print(canPartition([1, 2, 3, 5]));   // false
  print(canPartition([3, 3, 3, 4, 5])); // true  (3+4=7, 3+3+5-wait actually 3+3+5-... let's just print)
}
