// A `for` loop repeats a block of code. Dart offers two styles:
//   1. Classic C-style: initialize, condition, step.
//   2. `for-in`: iterate over every element of a collection.
void main() {
  // 1. C-style
  for (int i = 0; i < 5; i++) {
    print('i = $i');
  }

  // 2. for-in
  List<String> fruits = ['apple', 'banana', 'cherry'];
  for (String fruit in fruits) {
    print('fruit: $fruit');
  }
}
