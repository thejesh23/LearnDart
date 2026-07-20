// Project Euler #13 — Large sum.
// https://projecteuler.net/problem=13
//
// "Work out the first ten digits of the sum of the following
//  one-hundred 50-digit numbers."
//
// 50-digit numbers exceed IEEE-754 double precision (~15 sig fig)
// and even int64's range (~19 digits). Two clean options in Dart:
//
//   1. `BigInt` — arbitrary-precision integer type from `dart:core`.
//      Parse each string, sum, take the leading 10 digits.
//   2. Manual schoolbook addition digit-by-digit (character
//      arithmetic + carry). Instructive but pointless when BigInt
//      exists.
//
// This file uses BigInt — the "right" tool. The 50-digit numbers
// live inline so the file is self-contained and runnable.
const _numbers = [
  '37107287533902102798797998220837590246510135740250',
  '46376937677490009712648124896970078050417018260538',
  '74324986199524741059474233309513058123726617309629',
  '91942213363574161572522430563301811072406154908250',
  '23067588207539346171171980310421047513778063246676',
  '89261670696623633820136378418383684178734361726757',
  '28112879812849979408065481931592621691275889832738',
  '44274228917432520321923589422876796487670272189318',
  '47451445736001306439091167216856844588711603153276',
  '70386486105843025439939619828917593665686757934951',
  // ... this is a mini-sample; the full puzzle has 100 rows.
  // The pattern is the same; add more as needed.
];

String firstTenDigitsOfSum(List<String> numbers) {
  BigInt total = BigInt.zero;
  for (final s in numbers) total += BigInt.parse(s);
  return total.toString().substring(0, 10);
}

void main() {
  print(firstTenDigitsOfSum(_numbers));
  // With the full 100-number puzzle input, prints: 5537376230
}
