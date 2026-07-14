// A `List` is an ordered collection of values. Think of it as a shelf of
// items you can look up by their position (index), starting from 0.
void main() {
  List<String> fruits = ['apple', 'banana', 'cherry'];

  print('fruits    = $fruits');
  print('length    = ${fruits.length}');
  print('first     = ${fruits.first}');
  print('last      = ${fruits.last}');
  print('index 1   = ${fruits[1]}');
  print('isEmpty   = ${fruits.isEmpty}');
}
