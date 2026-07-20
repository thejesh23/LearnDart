// An Armstrong (narcissistic) number equals the sum of its digits each
// raised to the power of the digit count. 153 = 1^3 + 5^3 + 3^3, for
// example.
bool isArmstrong(int n) {
  if (n < 0) return false;
  final digits = n.toString().split('').map(int.parse).toList();
  final power = digits.length;
  int sum = 0;
  for (final d in digits) {
    int p = 1;
    for (int i = 0; i < power; i++) p *= d;
    sum += p;
  }
  return sum == n;
}

void main() {
  for (final n in [0, 1, 9, 10, 153, 154, 370, 371, 407, 9474]) {
    print('$n -> ${isArmstrong(n)}');
  }
}
