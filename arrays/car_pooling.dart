// Car Pooling: you drive a van of `capacity` seats along a 1-D
// road. `trips[i] = [numPassengers, from, to]` says a group boards
// at `from` and leaves at `to`. Can the van complete all trips
// without ever exceeding capacity?
//
// The line-sweep / difference-array trick: at each stop, add
// passengers who board and subtract passengers who leave. Instead
// of updating every stop between `from` and `to`, we +numPassengers
// at `from` and -numPassengers at `to`, then take a prefix sum.
// The prefix sum at index i tells you the head-count at stop i.
// If any prefix sum ever exceeds capacity, return false.
//
// The difference-array pattern is the workhorse of range-update /
// point-query problems: booking-schedule overlaps, "corporate
// flight bookings", and any interval-load problem. LeetCode #1094.
bool carPooling(List<List<int>> trips, int capacity) {
  final delta = List<int>.filled(1001, 0);
  int lastStop = 0;
  for (final t in trips) {
    final n = t[0], from = t[1], to = t[2];
    if (n > capacity) return false;
    delta[from] += n;
    delta[to] -= n;
    if (to > lastStop) lastStop = to;
  }
  int occupancy = 0;
  for (int i = 0; i <= lastStop; i++) {
    occupancy += delta[i];
    if (occupancy > capacity) return false;
  }
  return true;
}

void main() {
  print(carPooling([[2, 1, 5], [3, 3, 7]], 4)); // false (5 at t=3)
  print(carPooling([[2, 1, 5], [3, 3, 7]], 5)); // true
  print(carPooling([[2, 1, 5], [3, 5, 7]], 3)); // true (group 1 leaves at 5)
}
