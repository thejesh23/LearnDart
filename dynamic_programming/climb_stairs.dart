// Count the number of distinct ways to climb an n-stair staircase taking
// 1 or 2 steps at a time. Same recurrence as Fibonacci; O(1) space.
int climbStairs(int n) {
  if (n < 0) return 0;
  if (n < 2) return 1;
  int prev = 1, curr = 1;
  for (int i = 2; i <= n; i++) {
    final next = prev + curr;
    prev = curr;
    curr = next;
  }
  return curr;
}

void main() {
  for (final n in [0, 1, 2, 3, 4, 5, 10, 20]) {
    print('$n stairs -> ${climbStairs(n)} ways');
  }
}
