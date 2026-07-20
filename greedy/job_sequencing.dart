// Job sequencing with deadlines: each job takes one time slot and pays a
// profit only if completed on or before its deadline. Maximize total profit
// when at most one job runs per slot.
//
// The greedy insight: consider jobs in *descending profit* order and
// place each in the *latest still-free slot* on or before its deadline.
// Placing late (rather than as early as possible) leaves earlier slots
// open for higher-profit jobs with tight deadlines we haven't seen yet.
//
// Complexity: O(n · d_max) with the linear slot search shown here.
// A DSU-based variant (data_structures/disjoint_set.dart) finds the
// latest free slot in near-constant time, dropping this to O(n log n).
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
