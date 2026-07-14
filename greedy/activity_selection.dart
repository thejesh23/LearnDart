// Given activities with start and end times, select the maximum number
// that don't overlap. Sort by end time then greedily pick.
List<(int, int)> selectActivities(List<(int, int)> activities) {
  final sorted = List<(int, int)>.of(activities)
    ..sort((a, b) => a.$2.compareTo(b.$2));
  final chosen = <(int, int)>[];
  int lastEnd = -1 << 62;
  for (final a in sorted) {
    if (a.$1 >= lastEnd) {
      chosen.add(a);
      lastEnd = a.$2;
    }
  }
  return chosen;
}

void main() {
  final activities = <(int, int)>[
    (1, 3), (2, 5), (0, 6), (5, 7), (3, 9), (5, 9), (6, 10),
    (8, 11), (8, 12), (2, 14), (12, 16),
  ];
  print(selectActivities(activities));
}
