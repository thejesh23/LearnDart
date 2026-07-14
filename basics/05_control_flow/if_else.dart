// `if` runs a block only when its condition is true. `else` runs when it
// isn't. `else if` chains more conditions. Only booleans are accepted —
// no truthy/falsy conversions.
void main() {
  int temperature = 22;

  if (temperature > 30) {
    print("It's hot.");
  } else if (temperature > 20) {
    print("It's pleasant.");
  } else if (temperature > 10) {
    print("It's cool.");
  } else {
    print("It's cold.");
  }

  // Ternary form: `condition ? whenTrue : whenFalse` — good for short choices.
  String label = temperature > 20 ? 'warm' : 'chilly';
  print('label: $label');
}
