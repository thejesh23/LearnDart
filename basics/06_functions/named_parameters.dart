// Named parameters are passed by *name*, so at the call site you write
// `distance(from: 'A', to: 'B')` instead of relying on argument order.
//
// Wrap the parameters in `{ }`. By default they're optional; mark with
// `required` if the caller must supply them.
double distance({required double from, required double to, String units = 'km'}) {
  final d = (to - from).abs();
  print('($from -> $to) = $d $units');
  return d;
}

void main() {
  distance(from: 0, to: 42);
  distance(to: 100, from: 20, units: 'mi'); // order doesn't matter
}
