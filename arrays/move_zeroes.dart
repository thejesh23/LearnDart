// Move Zeroes: shift every 0 in an array to the end while keeping
// the non-zero elements in their original relative order. In place,
// O(n) time, O(1) space.
//
// The trick is the "write pointer" pattern (a.k.a. two-pointer,
// slow/fast): one index (`write`) tracks where the next non-zero
// should land; a second index (`read`) walks the array. Whenever
// `nums[read]` is non-zero, copy it to `nums[write]` and advance
// `write`. After the first pass, fill the remainder with zeros.
//
// This is the compaction primitive underlying "remove element",
// "remove duplicates from sorted array", and any in-place filter
// where order matters. LeetCode #283.
List<int> moveZeroes(List<int> nums) {
  int write = 0;
  for (int read = 0; read < nums.length; read++) {
    if (nums[read] != 0) {
      nums[write++] = nums[read];
    }
  }
  for (int i = write; i < nums.length; i++) nums[i] = 0;
  return nums;
}

void main() {
  print(moveZeroes([0, 1, 0, 3, 12]));   // [1, 3, 12, 0, 0]
  print(moveZeroes([0, 0, 1]));           // [1, 0, 0]
  print(moveZeroes([1, 2, 3]));           // [1, 2, 3]
  print(moveZeroes([]));                  // []
}
