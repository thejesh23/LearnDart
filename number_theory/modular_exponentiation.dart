// Compute (base^exp) mod m in O(log exp) via square-and-multiply.
int modPow(int base, int exp, int m) {
  if (m == 1) return 0;
  int result = 1;
  int b = base % m;
  int e = exp;
  while (e > 0) {
    if (e & 1 == 1) result = (result * b) % m;
    b = (b * b) % m;
    e >>= 1;
  }
  return result;
}

void main() {
  print(modPow(2, 10, 1000));      // 24
  print(modPow(3, 200, 13));       // 9
  print(modPow(7, 256, 13));       // 9
}
