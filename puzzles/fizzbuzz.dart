// FizzBuzz: print 1..n, replacing multiples of 3 with 'Fizz', multiples
// of 5 with 'Buzz', and multiples of both with 'FizzBuzz'.
//
// The trick most beginners get wrong: check the combined case (multiple
// of 15) *first*. Checking `i % 3 == 0` before `i % 15 == 0` swallows
// every multiple of 15 into 'Fizz' and you never emit 'FizzBuzz'.
//
// FizzBuzz is famous as a hiring-screen question because it's small
// enough to write in a minute yet still catches candidates who can't
// translate a plain-English spec into working code.
//
// Complexity: O(n) time, O(n) space (for the output list).
List<String> fizzBuzz(int n) {
  final out = <String>[];
  for (int i = 1; i <= n; i++) {
    if (i % 15 == 0) out.add('FizzBuzz');
    else if (i % 3 == 0) out.add('Fizz');
    else if (i % 5 == 0) out.add('Buzz');
    else out.add(i.toString());
  }
  return out;
}

void main() {
  for (final s in fizzBuzz(20)) print(s);
}
