// Collatz (a.k.a. 3n+1, hailstone) sequence. Repeatedly transform n:
//   n → n / 2      if n is even
//   n → 3n + 1     if n is odd
// until you reach 1. The *Collatz conjecture* states this always
// terminates, no matter what positive starting value you pick.
//
// Proposed by Lothar Collatz in 1937. Verified experimentally for
// every n up to ~2^68. No proof yet, and Paul Erdős famously said
// "mathematics may not be ready for such problems". Terence Tao made
// major partial progress in 2019.
//
// Behavior is chaotic — n = 27 takes 111 steps and peaks at 9,232.
// Complexity: unknown in the worst case! For practical n it terminates
// quickly.
List<int> collatzSequence(int n) {
  if (n < 1) throw ArgumentError('n must be positive');
  final seq = <int>[n];
  while (n != 1) {
    n = n.isEven ? n ~/ 2 : 3 * n + 1;
    seq.add(n);
  }
  return seq;
}

void main() {
  for (final n in [1, 6, 27, 97]) {
    final seq = collatzSequence(n);
    print('$n -> length ${seq.length}, peak ${seq.reduce((a, b) => a > b ? a : b)}');
  }
}
