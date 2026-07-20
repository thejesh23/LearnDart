// Bracket balance check: every opener has a matching closer *and*
// the pairs nest properly. So "([])" is valid but "([)]" is not.
//
// A canonical example of why the stack data structure exists: push
// each opener you see, and every closer must match the most recent
// unmatched opener — that's LIFO by definition. At the end, an
// empty stack means every opener was closed.
//
// Same shape underlies HTML/XML tag balance checking, expression
// evaluators, JSON parsers, and Ruby's `def...end` matching in code
// editors. Complexity: O(n) time and O(n) space (the stack).
//
// See data_structures/stack.dart for the general LIFO primitive.
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
