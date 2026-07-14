// A `Map` associates keys with values — a phone book, a config file, a
// cache. Look up a value by its key.
void main() {
  Map<String, int> ages = {
    'Ada': 36,
    'Alan': 41,
    'Grace': 85,
  };

  print('ages          = $ages');
  print("Ada's age     = ${ages['Ada']}");
  print("keys          = ${ages.keys.toList()}");
  print("values        = ${ages.values.toList()}");
  print("has 'Grace'?  = ${ages.containsKey('Grace')}");

  ages['Linus'] = 55; // add or update
  ages.remove('Alan');
  print('after edits   = $ages');

  // Looking up a missing key returns null (the map value type is nullable).
  int? unknown = ages['Nobody'];
  print('unknown       = $unknown');
}
