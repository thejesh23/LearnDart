// Decimal → binary conversion, from scratch (not using
// int.toRadixString). Repeatedly divide by 2; the remainder at
// each step is the next bit from the least-significant end.
//
// Because remainders emerge in reverse (LSB-first), we accumulate
// them and then reverse — or, equivalently, prepend. This is the
// paper-and-pencil algorithm every CS textbook opens with.
//
// The same "repeated division by base" recipe works for any base
// ≥ 2 (see conversions/decimal_to_hexadecimal.dart). Complexity:
// O(log n) divisions.
String decimalToBinary(int n) {
  if (n == 0) return '0';
  final negative = n < 0;
  int x = n.abs();
  final bits = <int>[];
  while (x > 0) {
    bits.add(x & 1);
    x >>= 1;
  }
  final buf = StringBuffer(negative ? '-' : '');
  for (int i = bits.length - 1; i >= 0; i--) buf.write(bits[i]);
  return buf.toString();
}

void main() {
  print(decimalToBinary(0));    // 0
  print(decimalToBinary(5));    // 101
  print(decimalToBinary(10));   // 1010
  print(decimalToBinary(255));  // 11111111
  print(decimalToBinary(-6));   // -110
}
