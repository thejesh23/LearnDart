// Decimal → hexadecimal conversion. Same divide-by-base recipe as
// conversions/decimal_to_binary.dart, but base 16 needs digits
// past 9 — we use '0'..'9' then 'A'..'F' for 10..15.
//
// Hex is compact for humans looking at bit patterns because each
// hex digit maps to exactly 4 bits (a nibble). That's why colors
// (#RRGGBB), memory addresses (0x7fff…), and file dumps (xxd, hex
// editors) are all written in hex. Complexity: O(log n).
String decimalToHex(int n) {
  const digits = '0123456789ABCDEF';
  if (n == 0) return '0';
  final negative = n < 0;
  int x = n.abs();
  final buf = StringBuffer();
  while (x > 0) {
    buf.write(digits[x & 0xF]);
    x >>= 4;
  }
  final chars = buf.toString().split('').reversed.join();
  return negative ? '-$chars' : chars;
}

void main() {
  print(decimalToHex(0));      // 0
  print(decimalToHex(10));     // A
  print(decimalToHex(255));    // FF
  print(decimalToHex(4096));   // 1000
  print(decimalToHex(-171));   // -AB
}
