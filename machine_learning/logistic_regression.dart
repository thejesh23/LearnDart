import 'dart:math';

// Binary logistic regression trained by batch gradient descent.
class LogisticRegression {
  final List<double> weights;
  double bias = 0;
  final double lr;
  final int epochs;

  LogisticRegression(int features, {this.lr = 0.1, this.epochs = 1000})
      : weights = List<double>.filled(features, 0);

  double _sigmoid(double z) => 1 / (1 + exp(-z));

  double _predictRaw(List<double> x) {
    double z = bias;
    for (int i = 0; i < x.length; i++) z += weights[i] * x[i];
    return _sigmoid(z);
  }

  int predict(List<double> x) => _predictRaw(x) >= 0.5 ? 1 : 0;

  void train(List<List<double>> xs, List<int> ys) {
    final n = xs.length;
    for (int e = 0; e < epochs; e++) {
      final gradW = List<double>.filled(weights.length, 0);
      double gradB = 0;
      for (int i = 0; i < n; i++) {
        final p = _predictRaw(xs[i]);
        final err = p - ys[i];
        for (int j = 0; j < weights.length; j++) {
          gradW[j] += err * xs[i][j];
        }
        gradB += err;
      }
      for (int j = 0; j < weights.length; j++) {
        weights[j] -= lr * gradW[j] / n;
      }
      bias -= lr * gradB / n;
    }
  }
}

void main() {
  // Learn logical OR.
  final xs = [[0.0, 0], [0, 1], [1, 0], [1, 1]];
  final ys = [0, 1, 1, 1];
  final lr = LogisticRegression(2)..train(xs, ys);
  for (final x in xs) print('OR$x -> ${lr.predict(x)}');
}
