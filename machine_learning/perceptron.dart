// Single-layer perceptron: iterative weight updates until the training
// examples are correctly classified (assuming they are linearly separable).
class Perceptron {
  final List<double> weights;
  double bias = 0;
  final double lr;

  Perceptron(int features, {this.lr = 0.1})
      : weights = List<double>.filled(features, 0);

  int predict(List<double> x) {
    double s = bias;
    for (int i = 0; i < x.length; i++) s += weights[i] * x[i];
    return s >= 0 ? 1 : 0;
  }

  void train(List<List<double>> xs, List<int> ys, {int epochs = 100}) {
    for (int e = 0; e < epochs; e++) {
      var errors = 0;
      for (int i = 0; i < xs.length; i++) {
        final pred = predict(xs[i]);
        final err = ys[i] - pred;
        if (err != 0) {
          errors++;
          for (int j = 0; j < weights.length; j++) {
            weights[j] += lr * err * xs[i][j];
          }
          bias += lr * err;
        }
      }
      if (errors == 0) break;
    }
  }
}

void main() {
  // Learn logical AND.
  final xs = [[0.0, 0], [0, 1], [1, 0], [1, 1]];
  final ys = [0, 0, 0, 1];
  final p = Perceptron(2)..train(xs, ys);
  for (final x in xs) {
    print('AND$x -> ${p.predict(x)}');
  }
  print('weights=${p.weights}, bias=${p.bias}');
}
