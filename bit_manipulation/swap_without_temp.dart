// XOR swap: no temporary variable required.
(int, int) xorSwap(int a, int b) {
  a ^= b;
  b ^= a;
  a ^= b;
  return (a, b);
}

void main() {
  int a = 7, b = 12;
  print('before: a=$a, b=$b');
  (a, b) = xorSwap(a, b);
  print('after : a=$a, b=$b');
}
