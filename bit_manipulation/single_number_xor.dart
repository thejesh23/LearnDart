// Given a list in which every element appears twice except one that
// appears once, find the odd element. XOR of every element gives the
// answer in O(n) time and O(1) space.
//
// Two properties of XOR make this work:
//   a ^ a == 0   (self-cancellation)
//   a ^ 0 == a   (identity)
// Also, XOR is associative and commutative, so the order of the fold
// doesn't matter — every pair cancels itself out and only the singleton
// survives.
//
// Alternative approaches: a hash-map count is O(n) time and O(n) space,
// so the XOR trick is strictly better. Generalizes to "three of each
// except one" with a two-counter trick, but the math gets subtle.
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
