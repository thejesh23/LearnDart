// Single hidden-layer neural network trained by backpropagation.
// Closes the arc from sigmoid.dart (activation) and perceptron.dart
// (linear threshold unit) to a full multi-layer network that can
// learn non-linear decision boundaries.
//
// Architecture: input(2) → hidden(4, sigmoid) → output(1, sigmoid).
// XOR is the canonical demonstration: no single linear boundary can
// separate its four points — a hidden layer creates the needed curve.
//
// Forward pass:
//   z1 = W1 · x + b1;   a1 = σ(z1)     hidden activations
//   z2 = W2 · a1 + b2;  a2 = σ(z2)     output activation
//
// Loss: mean squared error = (a2 − y)²
//
// Backward pass (chain rule, layer by layer):
//   δ2 = (a2 − y) * σ'(z2)             output error term
//   δ1 = (W2ᵀ · δ2) * σ'(z1)           hidden error term
//   ∂L/∂W = δ * aᵀ   (outer product)   gradient for each weight matrix
//
// Weight update (gradient descent):
//   W ← W − lr * ∂L/∂W
//   b ← b − lr * δ
//
// After ~10 000 iterations the network should output values close to
// 0, 1, 1, 0 for XOR inputs (0,0), (0,1), (1,0), (1,1).
//
// This is the same algorithm used in every deep learning framework;
// only the number of layers, activation functions, and optimisers differ.

import 'dart:math';

// ----- activation -------------------------------------------------------

double _sigmoid(double x) => 1.0 / (1.0 + exp(-x));
double _sigmoidPrime(double x) { final s = _sigmoid(x); return s * (1.0 - s); }

// ----- tiny matrix helpers (row-major flat List<double>) ----------------

typedef Mat = List<double>;

Mat _zeros(int rows, int cols) => List<double>.filled(rows * cols, 0.0);

double _get(Mat m, int rows, int cols, int r, int c) => m[r * cols + c];
void   _set(Mat m, int cols, int r, int c, double v) => m[r * cols + c] = v;

// result = A (rA × k) · B (k × cB)
Mat _matmul(Mat a, int rA, int k, Mat b, int cB) {
  final r = _zeros(rA, cB);
  for (int i = 0; i < rA; i++)
    for (int j = 0; j < cB; j++) {
      double s = 0;
      for (int l = 0; l < k; l++) s += _get(a, rA, k, i, l) * _get(b, k, cB, l, j);
      _set(r, cB, i, j, s);
    }
  return r;
}

// result = Aᵀ (cA × rA)
Mat _transpose(Mat a, int rA, int cA) {
  final r = _zeros(cA, rA);
  for (int i = 0; i < rA; i++)
    for (int j = 0; j < cA; j++) _set(r, rA, j, i, _get(a, rA, cA, i, j));
  return r;
}

// element-wise sigmoid and its derivative applied to a flat vector
Mat _applyS(Mat v)  => v.map(_sigmoid).toList();
Mat _applySP(Mat v) => v.map(_sigmoidPrime).toList();

// ----- network ----------------------------------------------------------

class NeuralNetwork {
  final int inputSize, hiddenSize, outputSize;
  late Mat W1, b1, W2, b2;

  NeuralNetwork(this.inputSize, this.hiddenSize, this.outputSize, {int seed = 0}) {
    final rng = Random(seed);
    double r() => (rng.nextDouble() - 0.5) * 2;
    W1 = List<double>.generate(hiddenSize * inputSize,  (_) => r());
    b1 = List<double>.generate(hiddenSize,              (_) => r());
    W2 = List<double>.generate(outputSize * hiddenSize, (_) => r());
    b2 = List<double>.generate(outputSize,              (_) => r());
  }

  // Returns (a1, z1, a2, z2) for use in backprop.
  (Mat, Mat, Mat, Mat) _forward(Mat x) {
    // z1 = W1 · x + b1  (hiddenSize × 1)
    final z1raw = _matmul(W1, hiddenSize, inputSize, x, 1);
    final z1 = List<double>.generate(hiddenSize, (i) => z1raw[i] + b1[i]);
    final a1 = _applyS(z1);

    // z2 = W2 · a1 + b2  (outputSize × 1)
    final z2raw = _matmul(W2, outputSize, hiddenSize, a1, 1);
    final z2 = List<double>.generate(outputSize, (i) => z2raw[i] + b2[i]);
    final a2 = _applyS(z2);

    return (a1, z1, a2, z2);
  }

  double predict(List<double> x) => _forward(x).$3[0];

  void train(List<List<double>> xs, List<double> ys,
             {int epochs = 10000, double lr = 0.1}) {
    for (int epoch = 0; epoch < epochs; epoch++) {
      double totalLoss = 0;
      for (int s = 0; s < xs.length; s++) {
        final x = xs[s], y = ys[s];
        final (a1, z1, a2, z2) = _forward(x);

        // ---- backward ----
        // Output delta: (a2 − y) * σ'(z2)
        final d2 = List<double>.generate(
            outputSize, (i) => (a2[i] - y) * _sigmoidPrime(z2[i]));

        // Hidden delta: (W2ᵀ · d2) * σ'(z1)
        final W2t = _transpose(W2, outputSize, hiddenSize);
        final d2col = d2;  // already a column vector
        final W2t_d2 = _matmul(W2t, hiddenSize, outputSize, d2col, 1);
        final sp1 = _applySP(z1);
        final d1 = List<double>.generate(hiddenSize, (i) => W2t_d2[i] * sp1[i]);

        // Update W2, b2
        for (int i = 0; i < outputSize; i++) {
          for (int j = 0; j < hiddenSize; j++) {
            W2[i * hiddenSize + j] -= lr * d2[i] * a1[j];
          }
          b2[i] -= lr * d2[i];
        }

        // Update W1, b1
        for (int i = 0; i < hiddenSize; i++) {
          for (int j = 0; j < inputSize; j++) {
            W1[i * inputSize + j] -= lr * d1[i] * x[j];
          }
          b1[i] -= lr * d1[i];
        }

        totalLoss += (a2[0] - y) * (a2[0] - y);
      }
      if (epoch % 2000 == 0) {
        print('  epoch $epoch  loss ${(totalLoss / xs.length).toStringAsFixed(6)}');
      }
    }
  }
}

void main() {
  // XOR: the classic non-linearly-separable problem.
  final xs = [[0.0, 0.0], [0.0, 1.0], [1.0, 0.0], [1.0, 1.0]];
  final ys = [0.0, 1.0, 1.0, 0.0];

  print('Training 2→4→1 network on XOR for 10 000 epochs...');
  final nn = NeuralNetwork(2, 4, 1, seed: 7);
  nn.train(xs, ys, epochs: 10000, lr: 0.5);

  print('\nPredictions after training:');
  for (int i = 0; i < xs.length; i++) {
    final p = nn.predict(xs[i]);
    print('  XOR(${xs[i]}) = ${ys[i].toInt()}  → predicted ${p.toStringAsFixed(4)}'
        '  (${p.round() == ys[i].toInt() ? "✓" : "✗"})');
  }
}
