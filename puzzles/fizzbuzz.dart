// FizzBuzz: print 1..n, replacing multiples of 3 with 'Fizz', multiples
// of 5 with 'Buzz', and multiples of both with 'FizzBuzz'.
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
