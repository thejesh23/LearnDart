// Shunting-yard algorithm — Dijkstra, 1961. Converts an infix
// arithmetic expression (the human-readable form, with precedence
// and parentheses) into Reverse Polish Notation (postfix), where
// evaluation needs no precedence rules at all — just a single stack.
//
// Algorithm (one left-to-right pass):
//   NUMBER  → emit directly to the output queue.
//   OPERATOR o1 → pop operators whose precedence is higher (or equal
//     and left-associative) and emit them; then push o1.
//   '('  → push onto the operator stack as a sentinel.
//   ')'  → pop-and-emit until the matching '(' is found; discard it.
//   End  → pop-and-emit all remaining operators.
//
// RPN evaluation: push numbers; on an operator pop two values, compute,
// push result. A simple stack machine with no grammar needed.
//
// Complexity: O(n) time, O(n) space for both the output queue and the
// operator stack.
//
// Why this matters: this is the algorithm inside most real-world
// expression evaluators (calculators, spreadsheets, compilers that
// don't use a full recursive-descent front-end).
// For the recursive-descent alternative, see recursive_descent_expr.dart.

const _prec = {'+': 1, '-': 1, '*': 2, '/': 2, '^': 3};
const _rightAssoc = {'^'};

// Converts an infix expression string to RPN.
// Output list contains `double` for numbers and `String` for operators.
List<Object> toRPN(String expr) {
  final output = <Object>[];
  final ops = <String>[];  // operator stack; '(' used as sentinel

  int i = 0;
  while (i < expr.length) {
    final ch = expr[i];
    if (ch == ' ') { i++; continue; }

    if ('+-*/^'.contains(ch)) {
      while (ops.isNotEmpty && ops.last != '(') {
        final p1 = _prec[ch]!;
        final p2 = _prec[ops.last] ?? 0;
        if (p2 > p1 || (p2 == p1 && !_rightAssoc.contains(ch))) {
          output.add(ops.removeLast());
        } else break;
      }
      ops.add(ch); i++; continue;
    }

    if (ch == '(') { ops.add('('); i++; continue; }

    if (ch == ')') {
      while (ops.isNotEmpty && ops.last != '(') output.add(ops.removeLast());
      if (ops.isNotEmpty) ops.removeLast();  // discard '('
      i++; continue;
    }

    // Number literal (integer or decimal)
    int j = i;
    while (j < expr.length && '0123456789.'.contains(expr[j])) j++;
    output.add(double.parse(expr.substring(i, j)));
    i = j;
  }
  while (ops.isNotEmpty) output.add(ops.removeLast());
  return output;
}

double evalRPN(List<Object> rpn) {
  final stack = <double>[];
  for (final tok in rpn) {
    if (tok is double) { stack.add(tok); continue; }
    final b = stack.removeLast(), a = stack.removeLast();
    stack.add(switch (tok as String) {
      '+'  => a + b,
      '-'  => a - b,
      '*'  => a * b,
      '/'  => a / b,
      '^'  => _intPow(a, b.toInt()),
      _    => throw StateError('unknown operator: $tok'),
    });
  }
  return stack.single;
}

double _intPow(double base, int exp) {
  double r = 1.0;
  for (int i = 0; i < exp; i++) r *= base;
  return r;
}

void main() {
  final cases = {
    '3 + 4 * 2':    11.0,   // precedence: * before +
    '(3 + 4) * 2':  14.0,   // parens override
    '2 ^ 3 ^ 2':   512.0,   // right-assoc: 2^(3^2)=2^9=512
    '10 / 2 + 3':    8.0,
  };
  for (final MapEntry(:key, :value) in cases.entries) {
    final rpn = toRPN(key);
    final rpnStr = rpn.map((t) => t is double ? t.toInt() : t).join(' ');
    final result = evalRPN(rpn);
    final ok = (result - value).abs() < 1e-9;
    print('${ok ? "✓" : "✗"}  $key  →  RPN: $rpnStr  →  $result');
  }
}
