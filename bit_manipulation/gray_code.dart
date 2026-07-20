// Binary-reflected Gray code: a sequence of integers in which each
// value differs from the next by exactly one bit. The encoding formula
// is beautifully simple: gray(n) = n XOR (n >> 1). The inverse (Gray
// to binary) needs to XOR-fold every right-shift of the Gray value.
//
// Why care? In hardware, when a multi-bit signal changes, if several
// bits transition at once you might briefly read a spurious value
// during the transition. With Gray coding only one bit ever changes,
// so any glitchy intermediate reading is still one of the two adjacent
// values. Used in rotary encoders, Karnaugh maps, K-anonymity
// permutations, and the Tower-of-Hanoi solution sequence.
int binaryToGray(int n) => n ^ (n >> 1);

int grayToBinary(int g) {
  int n = g;
  for (int shift = 1; (g >> shift) > 0; shift++) {
    n ^= g >> shift;
  }
  return n;
}

void main() {
  for (int i = 0; i < 8; i++) {
    final g = binaryToGray(i);
    print('n=$i  gray=${g.toRadixString(2).padLeft(3, '0')}  back=${grayToBinary(g)}');
  }
}
