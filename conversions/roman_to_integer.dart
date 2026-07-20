// Roman → integer. The elegant trick: walk left-to-right, and add
// the value of each symbol — unless the current symbol is smaller
// than the next, in which case subtract it instead. That handles
// all six subtractive pairs (IV, IX, XL, XC, CD, CM) without
// special cases.
//
// Example: "MCMXCIV"
//   M(1000) + C(100 < M-next-C? no, next is M so 100<1000 → -100)
//   ... total 1994.
//
// Complexity: O(n) over the string length. Pairs with
// conversions/integer_to_roman.dart. LeetCode #13.
int romanToInteger(String s) {
  const map = {
    'I': 1, 'V': 5, 'X': 10, 'L': 50,
    'C': 100, 'D': 500, 'M': 1000,
  };
  int total = 0;
  for (int i = 0; i < s.length; i++) {
    final v = map[s[i]] ?? (throw ArgumentError('bad char: ${s[i]}'));
    final next = i + 1 < s.length ? map[s[i + 1]]! : 0;
    if (v < next) total -= v; else total += v;
  }
  return total;
}

void main() {
  print(romanToInteger('III'));     // 3
  print(romanToInteger('IV'));      // 4
  print(romanToInteger('IX'));      // 9
  print(romanToInteger('LVIII'));   // 58
  print(romanToInteger('MCMXCIV')); // 1994
}
