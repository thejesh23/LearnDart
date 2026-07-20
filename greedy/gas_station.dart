// Circular route problem: n gas stations arranged in a loop. Station i
// has gas[i] fuel, and it costs cost[i] to reach the next station. Return
// the index to start from so you can complete the loop, or -1 if
// impossible.
//
// Two greedy insights:
//   1. If the total gas across all stations is less than the total cost,
//      no start point works. Otherwise a solution exists.
//   2. If the running tank goes negative right after leaving station i,
//      then no station in [start..i] can be the answer — every station in
//      that range would inherit the same deficit. Skip past to i+1.
//
// Complexity: O(n) time, O(1) space — a single sweep.
int canCompleteCircuit(List<int> gas, List<int> cost) {
  int total = 0, tank = 0, start = 0;
  for (int i = 0; i < gas.length; i++) {
    final diff = gas[i] - cost[i];
    total += diff;
    tank += diff;
    if (tank < 0) {
      start = i + 1;
      tank = 0;
    }
  }
  return total < 0 ? -1 : start;
}

void main() {
  print(canCompleteCircuit([1,2,3,4,5], [3,4,5,1,2])); // 3
  print(canCompleteCircuit([2,3,4],     [3,4,3]));     // -1
}
