// Kernighan's population-count algorithm. The key identity is that
// `n & (n - 1)` clears the lowest set bit of n — subtracting 1 flips
// every bit up to and including the lowest 1, and the AND then zeros
// them all. Loop until n is zero; each iteration clears exactly one
// bit, so the count of iterations is the answer.
//
// O(number of set bits) — much faster than checking each bit position
// when the input is sparse. Modern CPUs have a POPCNT instruction that
// does this in a single cycle; `int.bitLength` and bit tricks like
// this are what compilers lower to when POPCNT isn't available.
//
// Used in Hamming distance, bloom filters, chess move generation
// (bitboards), and cardinality estimation. See
// bit_manipulation/hamming_distance.dart for a direct application.
int countSetBits(int n) {
  int count = 0;
  int x = n;
  while (x != 0) {
    x &= x - 1;
    count++;
  }
  return count;
}

void main() {
  for (final n in [0, 1, 2, 3, 7, 255, 1024]) {
    print('$n -> ${countSetBits(n)} set bits');
  }
}
