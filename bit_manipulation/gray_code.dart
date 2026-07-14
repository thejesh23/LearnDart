// Standard binary-reflected Gray code: successive values differ in one bit.
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
