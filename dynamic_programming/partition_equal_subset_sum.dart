// Can the array be split into two subsets with equal sum? Reduces to a
// subset-sum question over half the total. Uses a 1-D bitset-style DP.
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
