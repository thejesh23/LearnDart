// Tower of Hanoi: three pegs, `n` disks of decreasing size stacked on the
// first. Move all disks to the third peg, one at a time, never placing a
// larger disk on a smaller one.
//
// The recursive insight: to move n disks from A to C using B as helper,
// first move n-1 disks from A to B (using C), then move the largest disk
// from A to C, then move the n-1 disks from B to C (using A). Every
// recursion is exactly this three-step dance on a smaller problem.
//
// Complexity: 2^n - 1 moves — the recurrence T(n) = 2·T(n-1) + 1. That
// exponential is a nice reminder that clean, correct recursion doesn't
// mean fast. 64 disks (the legendary temple version) would take
// ~584 billion years at one move per second.
void towerOfHanoi(int n, String from, String via, String to) {
  if (n == 0) return;
  towerOfHanoi(n - 1, from, to, via);
  print('move disk $n from $from to $to');
  towerOfHanoi(n - 1, via, from, to);
}

void main() {
  towerOfHanoi(3, 'A', 'B', 'C');
}
