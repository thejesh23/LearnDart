// XOR swap: exchange the values of two integer variables without
// allocating a temporary. Sequence:
//     a ^= b;   // a = a XOR b
//     b ^= a;   // b = original a (because b XOR (a XOR b) = a)
//     a ^= b;   // a = original b
//
// A famous parlor trick from the days when register pressure mattered.
// On modern hardware it's usually *slower* than a plain temp variable
// because the three sequential ops create a dependency chain the CPU
// can't parallelize — whereas `t = a; a = b; b = t` executes with
// full instruction-level parallelism.
//
// Gotcha: XOR swap breaks if the two locations *alias* (are the same
// variable) — you'd end up zeroing them. Never a problem with Dart's
// value semantics for ints, but it can bite in C when swapping
// through pointers.
(int, int) xorSwap(int a, int b) {
  a ^= b;
  b ^= a;
  a ^= b;
  return (a, b);
}

void main() {
  int a = 7, b = 12;
  print('before: a=$a, b=$b');
  (a, b) = xorSwap(a, b);
  print('after : a=$a, b=$b');
}
