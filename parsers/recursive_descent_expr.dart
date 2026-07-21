// Recursive-descent parser — turns a token stream into a computed
// value by mapping each grammar production directly to a function.
// The call stack mirrors the parse tree, so nesting depth equals
// parenthesis depth. No explicit stack or precedence table needed.
//
// Grammar (EBNF) for arithmetic with unary minus:
//   expr   = term   ( ('+' | '-') term   )*
//   term   = factor ( ('*' | '/') factor )*
//   factor = NUMBER | '(' expr ')' | '-' factor
//
// Precedence is structural: `expr` calls `term` calls `factor`,
// so '*' and '/' bind tighter than '+'/'-' by definition.
//
// Compared with shunting_yard.dart:
//   Both give identical results. Recursive descent is easier to
//   extend (add variables, function calls, if-expressions) and
//   produces better error messages because the stack trace directly
//   shows which grammar rule failed.
//
// Complexity: O(n) time (each token consumed once), O(d) call-stack
// depth where d is the maximum parenthesis nesting depth.

class _Parser {
  final List<String> _toks;
  int _pos = 0;

  _Parser(String src) : _toks = _lex(src);

  static List<String> _lex(String src) {
    final out = <String>[];
    int i = 0;
    while (i < src.length) {
      if (src[i] == ' ') { i++; continue; }
      if ('+-*/()'.contains(src[i])) { out.add(src[i++]); continue; }
      int j = i;
      while (j < src.length && '0123456789.'.contains(src[j])) j++;
      if (j > i) { out.add(src.substring(i, j)); i = j; continue; }
      throw FormatException('unexpected character: "${src[i]}"');
    }
    return out;
  }

  String get _cur => _pos < _toks.length ? _toks[_pos] : r'$';

  String _expect(String s) {
    if (_cur != s) throw FormatException('expected "$s", got "$_cur"');
    return _toks[_pos++];
  }

  double parse() {
    final v = _expr();
    if (_cur != r'$') throw FormatException('unexpected trailing: "$_cur"');
    return v;
  }

  // expr = term (('+' | '-') term)*
  double _expr() {
    var v = _term();
    while (_cur == '+' || _cur == '-') {
      final op = _toks[_pos++];
      v = op == '+' ? v + _term() : v - _term();
    }
    return v;
  }

  // term = factor (('*' | '/') factor)*
  double _term() {
    var v = _factor();
    while (_cur == '*' || _cur == '/') {
      final op = _toks[_pos++];
      v = op == '*' ? v * _factor() : v / _factor();
    }
    return v;
  }

  // factor = NUMBER | '(' expr ')' | '-' factor
  double _factor() {
    if (_cur == '-') { _pos++; return -_factor(); }
    if (_cur == '(') {
      _pos++;
      final v = _expr();
      _expect(')');
      return v;
    }
    final tok = _toks[_pos++];
    return double.tryParse(tok)
        ?? (throw FormatException('expected number, got "$tok"'));
  }
}

double evaluate(String expr) => _Parser(expr).parse();

void main() {
  final cases = {
    '3 + 4 * 2':          11.0,
    '(3 + 4) * 2':        14.0,
    '10 / 2 - 3':          2.0,
    '-5 + 3':             -2.0,
    '2 * (3 + (4 - 1))':  12.0,
    '-(3 + 2) * 4':      -20.0,
  };
  for (final MapEntry(:key, :value) in cases.entries) {
    final got = evaluate(key);
    final ok = (got - value).abs() < 1e-9;
    print('${ok ? "✓" : "✗"}  $key  =  $got');
  }
}
