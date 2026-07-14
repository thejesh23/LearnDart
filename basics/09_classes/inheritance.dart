// `extends` lets one class inherit fields and methods from another. The
// child can add new members and *override* inherited ones with `@override`.
class Animal {
  final String name;
  Animal(this.name);

  void describe() => print('$name is an animal');
}

class Cat extends Animal {
  Cat(super.name); // forward to Animal's constructor

  @override
  void describe() => print('$name is a cat that purrs');
}

void main() {
  final generic = Animal('Rex');
  final whiskers = Cat('Whiskers');

  generic.describe();
  whiskers.describe();
}
