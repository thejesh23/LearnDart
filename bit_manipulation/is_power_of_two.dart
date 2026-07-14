// A positive integer is a power of two iff exactly one bit is set:
//   n & (n - 1) == 0
bool isPowerOfTwo(int n) => n > 0 && (n & (n - 1)) == 0;

void main() {
  for (final n in [0, 1, 2, 3, 4, 5, 16, 1023, 1024]) {
    print('$n -> ${isPowerOfTwo(n)}');
  }
}
