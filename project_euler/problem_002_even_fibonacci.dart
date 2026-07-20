// Project Euler #2 — Even Fibonacci numbers.
// https://projecteuler.net/problem=2
//
// "By considering the terms in the Fibonacci sequence whose values
//  do not exceed four million, find the sum of the even-valued
//  terms."
//
// Key observation: every third Fibonacci number is even
// (odd, odd, even, odd, odd, even, ...). So we can skip the odd
// ones entirely by using the recurrence for the even subsequence:
//
//   E(n) = 4·E(n-1) + E(n-2),  starting E(1)=2, E(2)=8.
//
// This is ~3× faster than filtering an ordinary Fibonacci loop —
// a small win at limit=4·10⁶, but the technique generalises to any
// "every k-th term of a linear recurrence" problem.
int sumEvenFibonacci(int limit) {
  int a = 2, b = 8, sum = 0;
  if (limit < 2) return 0;
  sum = a;
  while (b <= limit) {
    sum += b;
    final next = 4 * b + a;
    a = b;
    b = next;
  }
  return sum;
}

void main() {
  print(sumEvenFibonacci(10));       // 10   (2 + 8)
  print(sumEvenFibonacci(4000000));  // 4613732  (the Project Euler answer)
}
