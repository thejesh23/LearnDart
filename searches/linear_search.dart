// Linear (sequential) search: scan every element, return the index of the
// first match, or -1 if the target isn't present.
//
// Works on *any* list — no ordering assumption, no preprocessing. That's
// its only advantage. Everything else is a tradeoff:
//   - O(n) worst and average case (target is at the end or absent).
//   - O(1) space, no allocations.
//   - Cache-friendly: sequential memory access is fast on modern CPUs.
//
// Prefer binary_search.dart on sorted data (O(log n)); a hash map for
// repeated lookups (O(1) average). Linear search still wins for small
// n (say, under ~20) — the constant factors of binary search and the
// branch misprediction on the mid comparison can lose to a plain loop.
int linearSearch(List<int> a, int target) {
  for (int i = 0; i < a.length; i++) {
    if (a[i] == target) return i;
  }
  return -1;
}

void main() {
  final data = [3, 8, 12, 5, 7];
  print(linearSearch(data, 12)); // 2
  print(linearSearch(data, 99)); // -1
}
