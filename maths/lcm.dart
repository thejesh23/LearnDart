int _gcd(int a, int b) {
  a = a.abs(); b = b.abs();
  while (b != 0) { final t = b; b = a % b; a = t; }
  return a;
}

int lcm(int a, int b) {
  if (a == 0 || b == 0) return 0;
  return (a ~/ _gcd(a, b)) * b;
}

void main() {
  print(lcm(4, 6));   // 12
  print(lcm(21, 6));  // 42
  print(lcm(0, 5));   // 0
}
