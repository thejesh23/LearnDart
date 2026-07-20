// Simple ordinary-least-squares linear regression y = a + b*x, closed
// form via the covariance / variance ratio.
(double intercept, double slope) linearRegression(
    List<double> xs, List<double> ys) {
  if (xs.length != ys.length || xs.isEmpty) {
    throw ArgumentError('xs and ys must be non-empty and equal length');
  }
  final n = xs.length;
  final meanX = xs.reduce((a, b) => a + b) / n;
  final meanY = ys.reduce((a, b) => a + b) / n;
  double num = 0, den = 0;
  for (int i = 0; i < n; i++) {
    num += (xs[i] - meanX) * (ys[i] - meanY);
    den += (xs[i] - meanX) * (xs[i] - meanX);
  }
  final slope = num / den;
  final intercept = meanY - slope * meanX;
  return (intercept, slope);
}

void main() {
  final xs = [1.0, 2, 3, 4, 5];
  final ys = [2.0, 4, 5, 4, 5];
  final (a, b) = linearRegression(xs, ys);
  print('y = ${a.toStringAsFixed(3)} + ${b.toStringAsFixed(3)} * x');
}
