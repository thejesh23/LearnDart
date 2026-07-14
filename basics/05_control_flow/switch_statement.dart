// A `switch` picks one of many branches based on a value. Dart's switch
// does *not* fall through by default — each `case` acts on its own.
void main() {
  String day = 'Tue';

  switch (day) {
    case 'Mon':
    case 'Tue':
    case 'Wed':
    case 'Thu':
    case 'Fri':
      print('weekday');
    case 'Sat':
    case 'Sun':
      print('weekend');
    default:
      print('unknown day');
  }
}
