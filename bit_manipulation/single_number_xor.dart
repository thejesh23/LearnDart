// Given a list where every element appears twice except one, find the odd
// element in O(n) time and O(1) space using XOR (a ^ a == 0, a ^ 0 == a).
int singleNumber(List<int> nums) {
  int acc = 0;
  for (final n in nums) acc ^= n;
  return acc;
}

void main() {
  print(singleNumber([2, 2, 1]));           // 1
  print(singleNumber([4, 1, 2, 1, 2]));     // 4
  print(singleNumber([1]));                  // 1
}
