// Are all brackets in `s` matched and properly nested? Handles (), [], {}.
bool isValidParentheses(String s) {
  const pairs = {')': '(', ']': '[', '}': '{'};
  final stack = <String>[];
  for (final ch in s.split('')) {
    if (ch == '(' || ch == '[' || ch == '{') {
      stack.add(ch);
    } else if (pairs.containsKey(ch)) {
      if (stack.isEmpty || stack.removeLast() != pairs[ch]) return false;
    }
  }
  return stack.isEmpty;
}

void main() {
  for (final s in ['()', '()[]{}', '(]', '([)]', '{[]}', '']) {
    print('"$s" -> ${isValidParentheses(s)}');
  }
}
