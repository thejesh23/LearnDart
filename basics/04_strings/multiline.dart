// Triple-quoted strings ('''...''' or """...""") span multiple lines
// without needing `\n` escapes. Prefix with `r` to make it a raw string —
// no interpolation or escape sequences, useful for regexes and file paths.
void main() {
  String haiku = '''
An old silent pond
A frog jumps into the pond—
Splash! Silence again.
''';
  print(haiku);

  String rawWindowsPath = r'C:\Users\Ada\Documents';
  print(rawWindowsPath);

  // Compare: without `r`, `\U` and `\D` would be treated as escape sequences.
}
