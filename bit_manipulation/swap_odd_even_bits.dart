// Swap every pair of adjacent bits in a 32-bit integer — bit 0
// with bit 1, bit 2 with bit 3, etc. So 0b10 becomes 0b01,
// 0b1011 (11) becomes 0b0111 (7), and so on.
//
// The one-liner uses two mask constants:
//   0xAAAAAAAA  = 0b10101010...  (every odd-indexed bit set)
//   0x55555555  = 0b01010101...  (every even-indexed bit set)
//
// Shift the odd bits right by 1 into their even positions, shift
// the even bits left by 1 into their odd positions, OR them
// together. Two shifts, two ANDs, one OR — six cycles on any
// modern CPU regardless of input size.
//
// Same "isolate lane, shift lane, OR" pattern powers bit-reversal
// (see bit_manipulation/reverse_bits.dart), byte-swap intrinsics
// (bswap on x86), and much of graphics / networking bit-plane
// manipulation.
int swapAdjacentBits(int n) {
  final oddMask = 0xAAAAAAAA;
  final evenMask = 0x55555555;
  return ((n & oddMask) >> 1) | ((n & evenMask) << 1);
}

void main() {
  print(swapAdjacentBits(2).toRadixString(2));  // 1
  print(swapAdjacentBits(1).toRadixString(2));  // 10
  print(swapAdjacentBits(23).toRadixString(2)); // 101011 → 010111 = 43
  print(swapAdjacentBits(43));                   // 23
  print(swapAdjacentBits(0xF0F0F0F0).toRadixString(16));  // f0f0f0f0 (unchanged)
}
