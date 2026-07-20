// Egg-drop puzzle: given `eggs` identical eggs and a `floors`-story
// building, find the minimum number of drops needed in the *worst case*
// to identify the highest floor from which an egg can be dropped
// without breaking.
//
// DP state: dp[e][f] = min worst-case drops with e eggs and f floors.
// From floor x you either break the egg (dp[e-1][x-1] to find the
// answer below) or don't (dp[e][f-x] to find the answer above); the
// worst case is the max, and you pick x to minimize that max.
//
// With 1 egg you must go linearly bottom-up (f drops). With enough
// eggs, binary-search gives log₂ f. In between there's a smoothly
// interpolating strategy — and a beautiful closed-form solution using
// binomial coefficients that this DP approximates.
//
// Complexity: O(eggs · floors^2) time; can be reduced to O(eggs · f · log f).
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
