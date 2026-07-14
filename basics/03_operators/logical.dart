// Logical operators combine booleans:
//   &&  logical AND — true only when both sides are true
//   ||  logical OR  — true when at least one side is true
//   !   logical NOT — flips true to false and vice versa
//
// `&&` and `||` short-circuit: they stop evaluating as soon as the answer
// is known. That's handy — and occasionally important, e.g. checking a
// value is non-null before using it.
void main() {
  bool hasKey = true;
  bool hasPermission = false;

  print('hasKey && hasPermission : ${hasKey && hasPermission}'); // false
  print('hasKey || hasPermission : ${hasKey || hasPermission}'); // true
  print('!hasPermission           : ${!hasPermission}');         // true

  // Short-circuit example: the right side never runs when the left is false.
  String? maybeName;
  bool nameStartsWithA =
      maybeName != null && maybeName.startsWith('A');
  print('nameStartsWithA : $nameStartsWithA');
}
