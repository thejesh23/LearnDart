// Jump search on a sorted list: leap forward in fixed-size blocks of
// √n elements to bracket the target's range, then do a linear scan
// within that block.
//
// The block size √n minimizes the sum "block jumps + linear scan
// within a block": worst case is √n + √n = 2√n comparisons, so
// O(√n) overall — slower than binary search's O(log n) but faster
// than linear.
//
// Where it wins: memory hierarchies where a "jump backward" is
// dramatically more expensive than a "jump forward" — magnetic tape,
// external merge storage. Binary search bounces around; jump search
// only ever reverses within one block. Rarely justified today.
//
// Complexity: O(√n) time, O(1) space.

import 'dart:math';

int jumpSearch(List<int> sorted, int target) {
  final n = sorted.length;
  if (n == 0) return -1;
  int step = sqrt(n).floor();
  int prev = 0;
  while (prev < n && sorted[min(step, n) - 1] < target) {
    prev = step;
    step += sqrt(n).floor();
    if (prev >= n) return -1;
  }
  for (int i = prev; i < min(step, n); i++) {
    if (sorted[i] == target) return i;
  }
  return -1;
}

void main() {
  final data = List<int>.generate(20, (i) => i * 2); // 0, 2, 4, ... 38
  print(jumpSearch(data, 18));
  print(jumpSearch(data, 15));
}
