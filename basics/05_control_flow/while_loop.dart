// A `while` loop repeats as long as its condition stays true. The condition
// is checked *before* each iteration, so if it's false to start with, the
// body never runs.
void main() {
  int countdown = 3;
  while (countdown > 0) {
    print('T-minus $countdown');
    countdown--;
  }
  print('Liftoff!');
}
