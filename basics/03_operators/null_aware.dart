// Because Dart tracks whether a value can be null, it provides a few
// short-hand operators for the common patterns around nullable values.
//
//   ??    "if left is null, use right"          value ?? fallback
//   ??=   "assign right only if left is null"   x ??= 42
//   ?.    "call this method only if not null"   maybeUser?.name
//   ?..   cascade version of ?.
//   !     "trust me, this isn't null right now" (throws if it *is* null)
void main() {
  String? username;
  String display = username ?? 'guest'; // fallback when null
  print('display: $display');

  int? count;
  count ??= 0;                          // set to 0 only because it was null
  count = count + 1;
  print('count after ??= and +1 : $count');

  String? maybeCity;
  int? length = maybeCity?.length;      // short-circuits to null instead of crashing
  print('length of maybeCity : $length');

  String definitelyThere = 'hello';
  String? nullable = definitelyThere;
  int strict = nullable!.length;        // `!` promises non-null; crashes if wrong
  print('strict length : $strict');
}
