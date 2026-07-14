// Inside a loop:
//   break    — exit the loop immediately
//   continue — skip the rest of this iteration and start the next one
void main() {
  // break: stop at the first negative number
  List<int> readings = [3, 7, 5, -1, 9, -4];
  for (int r in readings) {
    if (r < 0) {
      print('bad reading, stopping');
      break;
    }
    print('reading: $r');
  }

  print('---');

  // continue: print only the even numbers 1..10
  for (int i = 1; i <= 10; i++) {
    if (i % 2 != 0) continue;
    print('even: $i');
  }
}
