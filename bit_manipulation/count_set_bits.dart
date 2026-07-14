// Kernighan's algorithm: `n & (n - 1)` clears the lowest set bit.
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
