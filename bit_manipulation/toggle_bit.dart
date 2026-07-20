// The four fundamental single-bit operations. Each one is a one-liner
// built from a shifted 1-bit mask:
//
//   set    — OR  with (1 << i): forces bit i to 1
//   clear  — AND with ~(1 << i): forces bit i to 0
//   toggle — XOR with (1 << i): flips bit i
//   get    — SHIFT right by i then AND 1: reads bit i as 0 or 1
//
// These are the primitives every bit-manipulation trick is built on.
// Bit fields, flag registers, permission masks (Unix rwx), feature
// toggles, bitmap indexes — all of them reduce to variations of these
// four operations.

int setBit(int n, int i) => n | (1 << i);
int clearBit(int n, int i) => n & ~(1 << i);
int toggleBit(int n, int i) => n ^ (1 << i);
bool getBit(int n, int i) => (n >> i) & 1 == 1;

void main() {
  int n = 0;
  n = setBit(n, 3);   print('after setBit(0, 3):    $n (${n.toRadixString(2)})');
  n = setBit(n, 0);   print('after setBit(n, 0):    $n (${n.toRadixString(2)})');
  n = toggleBit(n, 3); print('after toggleBit(n, 3): $n (${n.toRadixString(2)})');
  n = clearBit(n, 0); print('after clearBit(n, 0):  $n (${n.toRadixString(2)})');
  print('getBit(9, 0): ${getBit(9, 0)}');
  print('getBit(9, 1): ${getBit(9, 1)}');
}
