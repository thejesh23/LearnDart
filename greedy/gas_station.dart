// Circular route problem: return the starting station index from which you
// can complete the circuit, or -1 if impossible. O(n) greedy — if the
// running tank drops below 0 at station i, the answer must be after i.
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
