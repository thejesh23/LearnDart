// Reverse the low `width` bits of `n`. Straightforward bit-by-bit
// approach: at each step, shift the result left and OR in the
// low bit of a right-shifted copy of the input.
//
// Faster variants exist: swap pairs of bits, then nibbles, then bytes
// using precomputed masks in O(log width) rather than O(width). Some
// architectures (ARM's RBIT, x86's BitScanForward + tricks) do it in
// one instruction.
//
// Applications: implementations of the fast Fourier transform reorder
// their inputs via bit reversal; low-level networking swaps endianness
// with a similar structure; PNG's interlacing pattern is bit-reversed
// Adam7 order.
int reverseBits(int n, [int width = 32]) {
  int result = 0;
  for (int i = 0; i < width; i++) {
    result = (result << 1) | ((n >> i) & 1);
  }
  return result;
}

void main() {
  print(reverseBits(1, 8).toRadixString(2).padLeft(8, '0'));   // 10000000
  print(reverseBits(0xAA, 8).toRadixString(2).padLeft(8, '0')); // 01010101
  print(reverseBits(43261596, 32));
}
