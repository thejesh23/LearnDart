// A mixin is a bundle of methods you can *mix in* to several classes
// without setting up an inheritance relationship. It's a way to share
// behavior when "is-a" wouldn't be accurate.
mixin Swimmer {
  void swim() => print('$runtimeType is swimming');
}

mixin Flyer {
  void fly() => print('$runtimeType is flying');
}

class Duck with Swimmer, Flyer {}
class Fish with Swimmer {}

void main() {
  Duck().swim();
  Duck().fly();
  Fish().swim();
}
