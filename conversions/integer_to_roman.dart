// Integer → Roman numeral, for 1..3999 (the classical range —
// Romans didn't have a compact notation past 3999).
//
// The trick is to greedily subtract the largest value that fits at
// each step. But Roman numerals have six "subtractive pairs" — CM
// (900), CD (400), XC (90), XL (40), IX (9), IV (4) — that must be
// tried in the same greedy pass, or you end up writing "DCCCC"
// instead of "CM". Encoding them as first-class values in the
// table sidesteps a mess of special-cases.
//
// Complexity: O(1) — the outer loop runs at most a fixed number of
// times regardless of input (bounded by 3999).
String integerToRoman(int n) {
  if (n < 1 || n > 3999) throw ArgumentError('n must be in 1..3999');
  const values = [1000, 900, 500, 400, 100, 90, 50, 40, 10, 9, 5, 4, 1];
  const symbols = ['M', 'CM', 'D', 'CD', 'C', 'XC', 'L', 'XL', 'X', 'IX', 'V', 'IV', 'I'];
  final buf = StringBuffer();
  for (int i = 0; i < values.length; i++) {
    while (n >= values[i]) {
      buf.write(symbols[i]);
      n -= values[i];
    }
  }
  return buf.toString();
}

void main() {
  print(integerToRoman(1));    // I
  print(integerToRoman(4));    // IV
  print(integerToRoman(9));    // IX
  print(integerToRoman(58));   // LVIII
  print(integerToRoman(1994)); // MCMXCIV
  print(integerToRoman(3999)); // MMMCMXCIX
}
