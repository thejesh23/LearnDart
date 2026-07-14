// Reverse the low `width` bits of `n` (default 32).
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
