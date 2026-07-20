// Fisher–Yates (a.k.a. Knuth) shuffle — an in-place algorithm that
// produces a uniformly random permutation of a list in O(n) time,
// O(1) extra space. Ronald Fisher and Frank Yates described the
// pencil-and-paper version in 1938; Richard Durstenfeld (1964) and
// Knuth (Vol 2) gave the modern in-place computer form.
//
// The idea: walk from the end to the start; at index i, swap
// nums[i] with nums[randomInt(0..i)] (inclusive of i). Every
// permutation is produced with probability exactly 1/n!.
//
// The famous bug is picking randomInt(0..n) at every step instead
// of (0..i) — that generates all n^n possibilities, most of which
// map to more than one output permutation, biasing the distribution.
// Guarantees hinge on the shrinking upper bound.
//
// Uses: shuffling a deck of cards, randomising sample-selection
// order in ML training, "pick k without replacement" (partial
// Fisher–Yates).
import 'dart:math';

void fisherYatesShuffle<T>(List<T> nums, {Random? rng}) {
  final r = rng ?? Random();
  for (int i = nums.length - 1; i > 0; i--) {
    final j = r.nextInt(i + 1);
    final tmp = nums[i];
    nums[i] = nums[j];
    nums[j] = tmp;
  }
}

void main() {
  final xs = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
  fisherYatesShuffle(xs, rng: Random(42));
  print(xs);
  fisherYatesShuffle(xs);
  print(xs);
}
