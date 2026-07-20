// Project Euler #17 — Number letter counts.
// https://projecteuler.net/problem=17
//
// "If all the numbers from 1 to 1000 (one thousand) inclusive were
//  written out in words, how many letters would be used?"
//
// Rules (British English, per Euler):
//   - Count letters only. Ignore spaces and hyphens.
//   - Use "and": 342 = "three hundred and forty-two" = 23 letters.
//
// This is a "spell out a number" problem — the same infrastructure
// underlying cheque-writing helpers, screen-readers for numeric
// data, and locale-aware number-formatters. The bounded 1..1000
// input keeps us from having to handle "million"/"billion".
const _ones = ['', 'one', 'two', 'three', 'four', 'five',
               'six', 'seven', 'eight', 'nine', 'ten',
               'eleven', 'twelve', 'thirteen', 'fourteen', 'fifteen',
               'sixteen', 'seventeen', 'eighteen', 'nineteen'];
const _tens = ['', '', 'twenty', 'thirty', 'forty',
               'fifty', 'sixty', 'seventy', 'eighty', 'ninety'];

String spellOut(int n) {
  if (n == 0) return 'zero';
  if (n == 1000) return 'one thousand';
  final buf = StringBuffer();
  if (n >= 100) {
    buf.write('${_ones[n ~/ 100]} hundred');
    n %= 100;
    if (n > 0) buf.write(' and ');
  }
  if (n >= 20) {
    buf.write(_tens[n ~/ 10]);
    if (n % 10 != 0) buf.write('-${_ones[n % 10]}');
  } else if (n > 0) {
    buf.write(_ones[n]);
  }
  return buf.toString();
}

int _letterCount(String s) {
  int c = 0;
  for (int i = 0; i < s.length; i++) {
    final ch = s.codeUnitAt(i);
    if ((ch >= 0x61 && ch <= 0x7A) || (ch >= 0x41 && ch <= 0x5A)) c++;
  }
  return c;
}

int totalLetters(int lo, int hi) {
  int total = 0;
  for (int i = lo; i <= hi; i++) total += _letterCount(spellOut(i));
  return total;
}

void main() {
  print(spellOut(342));              // three hundred and forty-two
  print(_letterCount(spellOut(342))); // 23
  print(totalLetters(1, 5));          // 19  (one,two,three,four,five)
  print(totalLetters(1, 1000));       // 21124 (the Project Euler answer)
}
