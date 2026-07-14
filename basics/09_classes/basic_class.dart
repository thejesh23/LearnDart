// A class is a blueprint for objects. It groups related data (fields) and
// the operations on that data (methods) into a single named type.
class Dog {
  String name;
  int ageYears;

  Dog(this.name, this.ageYears); // shorthand constructor

  void bark() => print('$name says: woof!');

  int ageInDogYears() => ageYears * 7;
}

void main() {
  final rex = Dog('Rex', 3);
  rex.bark();
  print('${rex.name} is ${rex.ageInDogYears()} in dog years');
}
