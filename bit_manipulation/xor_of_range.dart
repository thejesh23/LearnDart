// XOR of every integer in [1, n] in O(1) using the four-cycle pattern.
int xorFromOneTo(int n) => switch (n & 3) {
      0 => n,
      1 => 1,
      2 => n + 1,
      _ => 0,
    };

int xorInRange(int l, int r) => xorFromOneTo(r) ^ xorFromOneTo(l - 1);

void main() {
  for (int n = 0; n <= 8; n++) {
    print('XOR(1..$n) = ${xorFromOneTo(n)}');
  }
  print('XOR(3..9) = ${xorInRange(3, 9)}');
}
