// Perceptron: the original (1958, Rosenblatt) single-neuron linear
// binary classifier. Predict 1 if `w · x + b >= 0`, else 0. Learn by
// nudging the weights whenever a prediction is wrong:
//     w := w + lr · (y_true - y_pred) · x
//
// The perceptron convergence theorem guarantees this finds a separating
// hyperplane in a finite number of steps *if one exists*. If the data
// is not linearly separable (e.g. XOR), training loops forever without
// making progress — the historical realization of this in 1969 famously
// stalled neural-network research for a decade.
//
// Complexity: O(epochs · n · d) time. Modern deep networks are stacks
// of these units with non-linear activations, which lifts the
// linearity limitation entirely.
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
