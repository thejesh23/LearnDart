// A positive integer is a power of two iff its binary representation
// has exactly one 1-bit. The identity `n & (n - 1) == 0` captures that:
// `n - 1` flips the trailing zeros and the lone 1-bit, so ANDing with
// the original gives zero.
//
// The `n > 0` guard is essential — 0 also satisfies `n & (n - 1) == 0`
// (both sides are zero), and negative numbers in two's complement have
// their sign bit set too. Only positive powers of 2 qualify.
//
// Powers of two show up everywhere in systems programming: aligned
// allocations, hash table sizes, buffer bounds. The bit test lets you
// check in one instruction rather than dividing repeatedly.
bool isPowerOfTwo(int n) => n > 0 && (n & (n - 1)) == 0;

void main() {
  for (final n in [0, 1, 2, 3, 4, 5, 16, 1023, 1024]) {
    print('$n -> ${isPowerOfTwo(n)}');
  }
}
