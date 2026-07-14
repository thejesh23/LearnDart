// Dart can figure out ("infer") a variable's type from the value on the
// right-hand side. You can also spell the type out. Both styles are fine;
// pick whichever reads better.
void main() {
  // Inferred:
  var city = 'Bengaluru';        // String
  var population = 13_193_000;   // int  (underscores are just visual grouping)
  var averageAltitudeM = 920.0;  // double

  // Explicit:
  String country = 'India';
  int stateCount = 28;

  print('$city, $country — population $population, avg altitude ${averageAltitudeM}m');
  print('$country has $stateCount states');

  // Inference is decided at declaration, not at assignment. Once `city` is
  // a String, you cannot later put an int into it.
  // city = 42; // <-- would not compile
}
