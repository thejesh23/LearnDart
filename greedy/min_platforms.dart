// Minimum number of train platforms so no two trains simultaneously need
// the same one. Sort arrival and departure times, sweep through them in
// order, and track the maximum overlap.
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
