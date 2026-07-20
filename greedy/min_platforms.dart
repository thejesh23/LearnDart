// Minimum number of train platforms so no two trains are ever on the same
// platform. Equivalent to "maximum number of simultaneously-open intervals"
// — a common problem in resource-scheduling contexts.
//
// Sort arrivals and departures independently. Walk two pointers through
// both lists: every arrival at or before the next departure increments
// the platform count (and possibly a new max); every departure that
// happens first decrements. The running max across the sweep is the
// answer — a classic sweep-line technique.
//
// Complexity: O(n log n) time (sorting), O(1) extra space.
int minPlatforms(List<int> arrivals, List<int> departures) {
  final a = List<int>.of(arrivals)..sort();
  final d = List<int>.of(departures)..sort();
  int platforms = 0, maxPlatforms = 0;
  int i = 0, j = 0;
  while (i < a.length && j < d.length) {
    if (a[i] <= d[j]) {
      platforms++;
      if (platforms > maxPlatforms) maxPlatforms = platforms;
      i++;
    } else {
      platforms--;
      j++;
    }
  }
  return maxPlatforms;
}

void main() {
  final arrivals   = [900, 940, 950, 1100, 1500, 1800];
  final departures = [910, 1200, 1120, 1130, 1900, 2000];
  print(minPlatforms(arrivals, departures)); // 3
}
