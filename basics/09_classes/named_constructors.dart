// A single class can have multiple named constructors, each describing a
// distinct way to build an instance. Common naming conventions:
//   ClassName.fromX(...)  when constructing from another representation
//   ClassName.emptyX()    for a blank/default instance
class Temperature {
  final double celsius;

  Temperature(this.celsius);

  Temperature.fromFahrenheit(double f) : celsius = (f - 32) * 5 / 9;
  Temperature.fromKelvin(double k)     : celsius = k - 273.15;
  Temperature.freezing()               : celsius = 0;

  @override
  String toString() => '${celsius.toStringAsFixed(1)}°C';
}

void main() {
  print(Temperature(25));
  print(Temperature.fromFahrenheit(98.6));
  print(Temperature.fromKelvin(300));
  print(Temperature.freezing());
}
