// Sorted Squared Array: given a *sorted* array that may contain
// negatives, return the sorted array of the squares of every
// element. The lazy approach — square then re-sort — is O(n log n).
// A two-pointer merge does it in O(n) time and O(n) space.
//
// The insight: in the input, the largest-magnitude value is either
// at the far left (most-negative) or the far right (most-positive).
// Walk two pointers inward; at each step, take whichever pointer
// has the larger |value|, square it, and place it at the *end* of
// the output. Fill the output right-to-left.
//
// Classic two-pointer problem — the same converging-pointer pattern
// solves "reverse string", "container with most water", "3Sum's
// inner loop", and "trapping rain water". LeetCode #977.
List<int> sortedSquaredArray(List<int> nums) {
  final n = nums.length;
  final out = List<int>.filled(n, 0);
  int left = 0, right = n - 1, write = n - 1;
  while (left <= right) {
    final ls = nums[left] * nums[left];
    final rs = nums[right] * nums[right];
    if (ls > rs) {
      out[write--] = ls;
      left++;
    } else {
      out[write--] = rs;
      right--;
    }
  }
  return out;
}

void main() {
  print(sortedSquaredArray([-4, -1, 0, 3, 10])); // [0, 1, 9, 16, 100]
  print(sortedSquaredArray([-7, -3, 2, 3, 11])); // [4, 9, 9, 49, 121]
  print(sortedSquaredArray([1, 2, 3]));           // [1, 4, 9]
}
