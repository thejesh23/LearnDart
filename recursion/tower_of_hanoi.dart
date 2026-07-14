// Prints the moves needed to solve the Tower of Hanoi puzzle for `n` disks.
void towerOfHanoi(int n, String from, String via, String to) {
  if (n == 0) return;
  towerOfHanoi(n - 1, from, to, via);
  print('move disk $n from $from to $to');
  towerOfHanoi(n - 1, via, from, to);
}

void main() {
  towerOfHanoi(3, 'A', 'B', 'C');
}
