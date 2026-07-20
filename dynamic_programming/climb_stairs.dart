// Count distinct ways to climb an n-stair staircase taking 1 or 2
// steps at a time.
//
// The recurrence ways(n) = ways(n-1) + ways(n-2) is exactly Fibonacci
// (shifted by one), so the answer is F(n+1). The reason: any n-stair
// climb ends with either a 1-step (from n-1) or a 2-step (from n-2),
// giving a bijection to Fibonacci's construction.
//
// This is the classic first DP problem — small, tractable, and the
// "count ways" template extends to "3 step sizes", "k step sizes",
// "steps with variable costs" (climbing stairs with cost). The
// underlying pattern is the same: sum contributions from every
// reachable predecessor.
//
// Complexity: O(n) time, O(1) space.
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
