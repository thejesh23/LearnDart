// ReLU — Rectified Linear Unit. The workhorse activation of modern
// deep learning:
//
//   ReLU(x) = max(0, x)
//   ReLU'(x) = 1 if x > 0 else 0  (undefined at 0; convention: 0)
//
// Why it displaced sigmoid/tanh (see machine_learning/sigmoid.dart):
//   1. Non-saturating for x > 0 → gradients don't vanish across
//      deep stacks, training actually progresses.
//   2. Sparse activation — roughly half the units are zero at any
//      time, cheap forward and cheap gradient.
//   3. Trivial to compute (a compare and a max), extremely cache-
//      friendly on modern hardware.
//
// The famous failure mode is the "dying ReLU" — a neuron that
// receives only negative inputs will have gradient 0 and stop
// learning. Variants fix this: Leaky ReLU (small negative slope),
// PReLU (learnable slope), ELU (smooth negative tail), GELU
// (probabilistic gate — used in Transformers).
//
// See also machine_learning/perceptron.dart for the historical
// step-function ancestor.
double relu(double x) => x > 0 ? x : 0;

double reluDerivative(double x) => x > 0 ? 1 : 0;

double leakyRelu(double x, {double slope = 0.01}) => x > 0 ? x : slope * x;

double leakyReluDerivative(double x, {double slope = 0.01}) => x > 0 ? 1 : slope;

void main() {
  for (final x in [-2.0, -0.5, 0.0, 0.5, 2.0]) {
    print('relu($x) = ${relu(x)}   '
          "relu'($x) = ${reluDerivative(x)}   "
          'leakyRelu($x) = ${leakyRelu(x)}');
  }
}
