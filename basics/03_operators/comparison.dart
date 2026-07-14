// Comparison operators ask a yes/no question and produce a `bool`.
void main() {
  int x = 7;
  int y = 10;

  print('x == y : ${x == y}'); // equal to
  print('x != y : ${x != y}'); // not equal to
  print('x <  y : ${x < y}');
  print('x <= y : ${x <= y}');
  print('x >  y : ${x > y}');
  print('x >= y : ${x >= y}');

  // `==` compares values for the built-in types. For your own classes you
  // can override `==` — otherwise it defaults to "is this the same object?".
  String a = 'hello';
  String b = 'hel' 'lo';
  print('"hello" == "hel" "lo" : ${a == b}'); // true — same characters
}
