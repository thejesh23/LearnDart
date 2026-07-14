int linearSearch(List<int> a, int target) {
  for (int i = 0; i < a.length; i++) {
    if (a[i] == target) return i;
  }
  return -1;
}

void main() {
  final data = [3, 8, 12, 5, 7];
  print(linearSearch(data, 12)); // 2
  print(linearSearch(data, 99)); // -1
}
