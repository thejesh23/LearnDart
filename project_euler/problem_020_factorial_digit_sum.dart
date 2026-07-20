// Project Euler #20 — Factorial digit sum.
// https://projecteuler.net/problem=20
//
// "n! means n × (n − 1) × … × 3 × 2 × 1. For example,
//  10! = 3628800, and the sum of its digits is 27. Find the sum
//  of the digits in the number 100!"
//
// 100! has 158 digits (about 9.33·10¹⁵⁷) — vastly beyond 64-bit
// int. So we compute the factorial with `BigInt`, then peel off
// digits with %10 / ~/10.
//
// A subtle point: converting BigInt to a decimal string and
// summing character codes is fine here (100! is only 158 digits),
// but for really large n the arithmetic-loop approach below is
// allocation-free and clearer about what "sum of digits" means.
BigInt _factorial(int n) {
  var f = BigInt.one;
  for (int i = 2; i <= n; i++) f *= BigInt.from(i);
  return f;
}

int factorialDigitSum(int n) {
  var f = _factorial(n);
  int sum = 0;
  while (f > BigInt.zero) {
    sum += (f % BigInt.from(10)).toInt();
    f = f ~/ BigInt.from(10);
  }
  return sum;
}

void main() {
  print(factorialDigitSum(10));   // 27
  print(factorialDigitSum(100));  // 648 (the Project Euler answer)
}
