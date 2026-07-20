// Rotate an n×n matrix 90° clockwise in place. Transpose then reverse
// each row.
void rotateMatrix90CW(List<List<int>> m) {
  final n = m.length;
  for (int i = 0; i < n; i++) {
    for (int j = i + 1; j < n; j++) {
      final t = m[i][j]; m[i][j] = m[j][i]; m[j][i] = t;
    }
  }
  for (final row in m) {
    for (int i = 0, j = row.length - 1; i < j; i++, j--) {
      final t = row[i]; row[i] = row[j]; row[j] = t;
    }
  }
}

void main() {
  final m = [
    [1, 2, 3],
    [4, 5, 6],
    [7, 8, 9],
  ];
  rotateMatrix90CW(m);
  for (final row in m) print(row);
}
