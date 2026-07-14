// A String is a sequence of characters. In Dart you can wrap the text in
// either single quotes 'like this' or double quotes "like this" — they are
// interchangeable. Pick the one that lets you avoid escaping inner quotes.
void main() {
  String greeting = 'Hello';
  String name = "Ada";

  // Concatenate with `+` or by putting two literals next to each other.
  String hi = greeting + ', ' + name + '!';
  String hi2 = 'Hello' ', ' 'Ada' '!'; // adjacent-literal join, no `+` needed

  print(hi);
  print(hi2);

  // Strings know their length and can be indexed via `codeUnitAt` / `[]`.
  print('length of "$name" is ${name.length}');
  print('first character: ${name[0]}');
}
