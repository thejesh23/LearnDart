// A closure is a function that "remembers" variables from the scope where
// it was created, even after that scope has finished running. It's a small
// idea with big consequences — it's how you build counters, caches,
// generators, and more.
Function makeCounter() {
  int count = 0;
  return () {
    count++;
    return count;
  };
}

void main() {
  final counter = makeCounter();
  print(counter()); // 1
  print(counter()); // 2
  print(counter()); // 3

  // Each call to makeCounter() creates a fresh `count`.
  final other = makeCounter();
  print(other());   // 1 — independent from `counter`
}
