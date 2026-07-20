// Boyer–Moore Majority Vote — find the majority element (one that
// appears > n/2 times) of an array in O(n) time and O(1) space.
// Devised by Bob Boyer and J Strother Moore in 1980.
//
// The intuition: think of it as a duel. Pair each occurrence of
// the majority element with an occurrence of any other. Because
// the majority element is strictly more than half, it will always
// "win" — after all pairings are cancelled out, at least one copy
// of it survives.
//
// The algorithm implements the cancelling with two variables:
//   candidate — the currently-alive suspect
//   count     — how many "lives" it has left
// Increment count when we see the candidate; otherwise decrement,
// and when count hits 0 adopt the next element as the new
// candidate.
//
// Caveat: this returns *a* candidate. If the input is not
// guaranteed to have a majority, do a second O(n) pass to verify
// the candidate actually beats n/2. Related: LeetCode #169.
int? majorityElement(List<int> nums) {
  if (nums.isEmpty) return null;
  int candidate = nums[0], count = 0;
  for (final v in nums) {
    if (count == 0) candidate = v;
    if (v == candidate) count++; else count--;
  }
  int seen = 0;
  for (final v in nums) if (v == candidate) seen++;
  return seen * 2 > nums.length ? candidate : null;
}

void main() {
  print(majorityElement([3, 2, 3]));                    // 3
  print(majorityElement([2, 2, 1, 1, 1, 2, 2]));         // 2
  print(majorityElement([1, 2, 3, 4]));                  // null (no majority)
  print(majorityElement([]));                            // null
}
