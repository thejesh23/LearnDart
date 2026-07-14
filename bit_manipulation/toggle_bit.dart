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
