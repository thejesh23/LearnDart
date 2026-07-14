// Strings have many built-in methods for inspecting and transforming text.
// This file surveys the ones you'll reach for most often.
void main() {
  String s = '  Hello, Dart!  ';

  print('original     : "$s"');
  print('length       : ${s.length}');
  print('trim         : "${s.trim()}"');
  print('toLowerCase  : "${s.toLowerCase()}"');
  print('toUpperCase  : "${s.toUpperCase()}"');
  print('contains Dart: ${s.contains("Dart")}');
  print('startsWith " ": ${s.startsWith(" ")}');
  print('endsWith "  ": ${s.endsWith("  ")}');
  print('replaceAll   : "${s.replaceAll(" ", "_")}"');
  print('split on "," : ${s.split(",")}');
  print('substring 2-7: "${s.substring(2, 7)}"');
}
