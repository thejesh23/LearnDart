import 'dart:math';

double euclideanDistance((double, double) a, (double, double) b) {
  final dx = a.$1 - b.$1;
  final dy = a.$2 - b.$2;
  return sqrt(dx * dx + dy * dy);
}

double manhattanDistance((double, double) a, (double, double) b) =>
    (a.$1 - b.$1).abs() + (a.$2 - b.$2).abs();

double chebyshevDistance((double, double) a, (double, double) b) {
  final dx = (a.$1 - b.$1).abs();
  final dy = (a.$2 - b.$2).abs();
  return dx > dy ? dx : dy;
}

void main() {
  final a = (0.0, 0.0);
  final b = (3.0, 4.0);
  print('euclidean: ${euclideanDistance(a, b)}');
  print('manhattan: ${manhattanDistance(a, b)}');
  print('chebyshev: ${chebyshevDistance(a, b)}');
}
