// The Hamming distance between two equal-length values is the number
// of positions where the bits differ. For integers: XOR the two values
// (giving 1 in every differing position) and popcount the result.
//
// Uses Kernighan's popcount trick from
// bit_manipulation/count_set_bits.dart — see that file for details.
//
// Applications: error-correcting codes rate a code by its minimum
// Hamming distance (larger => more errors correctable); locality-
// sensitive hashing uses Hamming distance to approximate similarity;
// biology compares DNA sequences by treating them as strings and
// counting mismatches (essentially string-Hamming). Complexity: O(k)
// where k is the number of differing bits.
int hammingDistance(int a, int b) {
  int x = a ^ b;
  int count = 0;
  while (x != 0) {
    x &= x - 1;
    count++;
  }
  return count;
}

void main() {
  print(hammingDistance(1, 4));  // 2  (0001 vs 0100)
  print(hammingDistance(3, 1));  // 1  (0011 vs 0001)
  print(hammingDistance(0, 0xFF)); // 8
}
