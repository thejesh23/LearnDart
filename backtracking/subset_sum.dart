// Enumerate every subset of `nums` that sums to `target`.
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
