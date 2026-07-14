// The Hamming distance is the number of differing bits between two integers.
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
