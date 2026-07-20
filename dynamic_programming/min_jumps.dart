// Minimum Number of Jumps to reach the end. Given an array where
// each element is the maximum jump length from that position,
// what is the fewest jumps to reach the last index (starting from
// index 0)?
//
// Two well-known solutions:
//
//   1. DP in O(n²): dp[i] = min(dp[j] + 1) over all j < i with
//      j + arr[j] ≥ i. Straight-forward, easy to reason about.
//   2. Greedy BFS-layer in O(n): treat reachable indices as BFS
//      levels. Track the furthest we can reach in the current
//      level; when we advance past its end, we've made one more
//      jump and expand to the next level.
//
// This file shows both. The greedy version is preferable in
// practice — same result, drastically fewer operations for large
// arrays. LeetCode #45.
import 'dart:math';

int minJumpsDp(List<int> arr) {
  final n = arr.length;
  if (n <= 1) return 0;
  final dp = List<int>.filled(n, 1 << 30);
  dp[0] = 0;
  for (int i = 1; i < n; i++) {
    for (int j = 0; j < i; j++) {
      if (arr[j] + j >= i) dp[i] = min(dp[i], dp[j] + 1);
    }
  }
  return dp[n - 1];
}

int minJumpsGreedy(List<int> arr) {
  final n = arr.length;
  if (n <= 1) return 0;
  int jumps = 0, currentEnd = 0, farthest = 0;
  for (int i = 0; i < n - 1; i++) {
    if (i + arr[i] > farthest) farthest = i + arr[i];
    if (i == currentEnd) {
      jumps++;
      currentEnd = farthest;
      if (currentEnd >= n - 1) break;
    }
  }
  return jumps;
}

void main() {
  print(minJumpsGreedy([2, 3, 1, 1, 4]));                // 2   ([2->3->end])
  print(minJumpsGreedy([2, 3, 0, 1, 4]));                // 2
  print(minJumpsGreedy([3, 4, 2, 1, 2, 3, 7, 1, 1, 1])); // 3
  print(minJumpsDp([2, 3, 1, 1, 4]));                    // 2
}
