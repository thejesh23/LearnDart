// Recursive Euclidean algorithm.
int gcdRecursive(int a, int b) {
  a = a.abs(); b = b.abs();
  return b == 0 ? a : gcdRecursive(b, a % b);
}

void main() {
  print(gcdRecursive(48, 18));
  print(gcdRecursive(100, 75));
  print(gcdRecursive(17, 13));
}
