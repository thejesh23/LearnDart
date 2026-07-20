// Rotate an n×n matrix 90° clockwise in place with two O(n^2) passes:
//   1. Transpose across the main diagonal (swap m[i][j] with m[j][i]).
//   2. Reverse each row.
//
// The mathematical identity behind this: rotating a matrix by 90° CW
// is equivalent to transposing and then flipping horizontally.
// Counter-clockwise = transpose then flip vertically. 180° = flip
// horizontally then flip vertically. Great mental image for keeping
// the eight image-transform combinations straight.
//
// Complexity: O(n^2) time (necessary — must touch every element),
// O(1) extra space. Classic interview question because it exercises
// index arithmetic, in-place manipulation, and multi-pass thinking.
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
