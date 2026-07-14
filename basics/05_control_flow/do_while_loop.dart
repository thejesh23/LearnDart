// `do { ... } while (condition);` is like `while`, but the condition is
// checked *after* the body. That guarantees the body runs at least once —
// useful for things like "prompt the user, then check the answer".
void main() {
  int attempts = 0;
  int secret = 3;
  int guess;

  do {
    guess = attempts + 1; // pretend the user typed this
    attempts++;
    print('attempt $attempts: guess = $guess');
  } while (guess != secret);

  print('correct in $attempts attempts');
}
