// Dart has two number types:
//   int    — whole numbers (no decimal point):        1, 42, -7
//   double — numbers with a fractional part:         1.0, 3.14, -0.5
//
// Both are subtypes of `num`, so if you need to accept either, use `num`.
void main() {
  int wholeCount = 5;
  double temperature = 98.6;
  num anyNumber = 42; // could be assigned an int or a double later

  print('wholeCount   = $wholeCount');
  print('temperature  = $temperature');
  print('anyNumber    = $anyNumber');

  // Integer arithmetic stays an int; mixing with a double gives a double.
  int sum = 2 + 3;
  double mixed = 2 + 3.5;
  print('2 + 3     = $sum   (int)');
  print('2 + 3.5   = $mixed (double)');

  // Convert between them explicitly when you need to.
  double d = wholeCount.toDouble();
  int i = temperature.toInt(); // truncates toward zero: 98.6 -> 98
  print('int -> double : $d');
  print('double -> int : $i');
}
