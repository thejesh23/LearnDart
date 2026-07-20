// XOR of every integer from 1 to n in O(1). The cumulative XOR
// XOR(1..n) has a period-4 pattern depending on n mod 4:
//     n % 4 == 0 -> n
//     n % 4 == 1 -> 1
//     n % 4 == 2 -> n + 1
//     n % 4 == 3 -> 0
// Once you spot the pattern (write out the first dozen values and
// eyeball), the closed form saves the O(n) loop.
//
// Range XOR uses XOR's self-inverse property: XOR(l..r) is
// XOR(1..r) ^ XOR(1..l-1). The same "prefix trick" that lets you
// compute range sums from prefix sums, applied to XOR.
//
// Complexity: O(1) time and space.
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
