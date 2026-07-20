// Collatz (3n + 1) sequence: repeatedly n -> n/2 (if even) or 3n+1 (if
// odd) until you reach 1. Conjecturally always terminates.
List<int> collatzSequence(int n) {
  if (n < 1) throw ArgumentError('n must be positive');
  final seq = <int>[n];
  while (n != 1) {
    n = n.isEven ? n ~/ 2 : 3 * n + 1;
    seq.add(n);
  }
  return seq;
}

void main() {
  for (final n in [1, 6, 27, 97]) {
    final seq = collatzSequence(n);
    print('$n -> length ${seq.length}, peak ${seq.reduce((a, b) => a > b ? a : b)}');
  }
}
