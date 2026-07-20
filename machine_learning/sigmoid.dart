// Sigmoid activation function:
//
//   σ(x) = 1 / (1 + e^(-x))
//
// The classic S-curve. Maps ℝ → (0, 1) smoothly, monotonically,
// and with a "soft threshold" around 0. Its derivative has the
// self-referential form  σ'(x) = σ(x) · (1 − σ(x))  — a big
// convenience when back-propagating through it, because the
// forward-pass output feeds the backward-pass gradient with no
// extra work.
//
// Historically the default hidden-layer activation in the 90s.
// Modern deep networks prefer ReLU (see
// machine_learning/relu.dart) because sigmoid saturates for large
// |x| — the gradient goes to ≈0, and stacked sigmoids cause
// vanishing gradients that stall training.
//
// Still standard as the final activation for binary classification
// (its output is a valid probability) and inside gates of LSTM /
// GRU recurrent cells. See also
// machine_learning/logistic_regression.dart, whose "logistic" is
// this same function.
import 'dart:math';

double sigmoid(double x) => 1 / (1 + exp(-x));

double sigmoidDerivative(double x) {
  final s = sigmoid(x);
  return s * (1 - s);
}

void main() {
  for (final x in [-3.0, -1.0, 0.0, 1.0, 3.0]) {
    print('σ($x) = ${sigmoid(x).toStringAsFixed(4)}   '
          'σ\'($x) = ${sigmoidDerivative(x).toStringAsFixed(4)}');
  }
  // σ'(0) = 0.25, the maximum. Away from 0, gradient shrinks fast.
}
