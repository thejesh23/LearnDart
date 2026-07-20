// Simple ordinary-least-squares linear regression: find the line
// y = a + b·x that minimizes the sum of squared vertical distances to
// the data points.
//
// Closed-form solution: slope b = cov(x, y) / var(x); intercept a =
// mean(y) - b · mean(x). No iteration, no learning rate, no
// convergence to worry about — just one pass through the data.
//
// Assumes a linear relationship, roughly normal residuals, and no
// severe outliers (squared error is very sensitive to them). For
// multivariate or non-linear cases, extend to matrix form
// (X^T X)^-1 X^T y or use gradient descent — see
// machine_learning/logistic_regression.dart for the gradient shape.
//
// Complexity: O(n) time, O(1) space.
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
