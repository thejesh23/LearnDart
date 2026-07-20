// Egg drop puzzle: given `eggs` eggs and a `floors`-story building, find
// the minimum number of trials needed to identify the highest safe floor
// in the worst case.
int eggDrop(int eggs, int floors) {
  final dp = List.generate(eggs + 1, (_) => List<int>.filled(floors + 1, 0));
  for (int e = 1; e <= eggs; e++) {
    dp[e][1] = 1;
    dp[e][0] = 0;
  }
  for (int f = 1; f <= floors; f++) {
    dp[1][f] = f;
  }
  for (int e = 2; e <= eggs; e++) {
    for (int f = 2; f <= floors; f++) {
      dp[e][f] = 1 << 30;
      for (int x = 1; x <= f; x++) {
        final worst = 1 + (dp[e - 1][x - 1] > dp[e][f - x]
            ? dp[e - 1][x - 1]
            : dp[e][f - x]);
        if (worst < dp[e][f]) dp[e][f] = worst;
      }
    }
  }
  return dp[eggs][floors];
}

void main() {
  print(eggDrop(2, 10));  // 4
  print(eggDrop(2, 36));  // 8
  print(eggDrop(3, 14));  // 4
}
