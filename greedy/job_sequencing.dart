// Each job has a deadline and a profit. Complete at most one job per slot.
// Sort by profit descending, then assign each job to the latest free slot
// on or before its deadline.
(int totalProfit, List<String> chosen) jobSequencing(
    List<(String id, int deadline, int profit)> jobs) {
  final sorted = List<(String, int, int)>.of(jobs)
    ..sort((a, b) => b.$3.compareTo(a.$3));
  final maxDeadline = jobs.map((j) => j.$2).fold(0, (a, b) => a > b ? a : b);
  final slots = List<String?>.filled(maxDeadline, null);
  int profit = 0;
  for (final (id, deadline, p) in sorted) {
    for (int s = deadline - 1; s >= 0; s--) {
      if (slots[s] == null) {
        slots[s] = id;
        profit += p;
        break;
      }
    }
  }
  return (profit, [for (final s in slots) if (s != null) s]);
}

void main() {
  final jobs = <(String, int, int)>[
    ('a', 2, 100), ('b', 1, 19), ('c', 2, 27),
    ('d', 1, 25), ('e', 3, 15),
  ];
  print(jobSequencing(jobs)); // (142, [c, a, e])
}
