// Project Euler #14 — Longest Collatz sequence.
// https://projecteuler.net/problem=14
//
// "The following iterative sequence is defined for the set of
//  positive integers:
//      n → n/2   (n even)
//      n → 3n+1  (n odd)
//  Which starting number, under one million, produces the longest
//  chain?" (Chain length includes the terminating 1.)
//
// A brute walk from each starting value is possible but repeats
// enormous amounts of work. The killer optimisation is *memoisation*:
// once you know the chain length for 25, you know it for every
// number that ever transitions through 25.
//
// Complexity: amortised O(1) per starting value once the memo warms
// up — total is roughly linear in the answer bound. Watch out: the
// intermediate values in the Collatz chain can exceed the starting
// value substantially, so if you were doing this in a fixed-width
// language you'd need 64-bit arithmetic. Dart's `int` is 64 bits
// on native and gives you BigInt fallback on the web.
int startingNumberWithLongestChain(int limit) {
  final memo = <int, int>{1: 1};
  int chain(int n) {
    final cached = memo[n];
    if (cached != null) return cached;
    final next = n.isEven ? n ~/ 2 : 3 * n + 1;
    final len = 1 + chain(next);
    memo[n] = len;
    return len;
  }

  int bestStart = 1, bestLen = 0;
  for (int i = 1; i < limit; i++) {
    final len = chain(i);
    if (len > bestLen) { bestLen = len; bestStart = i; }
  }
  return bestStart;
}

void main() {
  print(startingNumberWithLongestChain(100));      // 97   (chain of 119)
  print(startingNumberWithLongestChain(1000000));  // 837799 (the Euler answer)
}
