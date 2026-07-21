// Tokeniser — the first stage of any parser, compiler, or interpreter.
// Given raw source text it produces a flat sequence of *tokens*: the
// smallest meaningful units (a number literal, an operator symbol, a
// parenthesis). Everything downstream works on tokens, not characters.
//
// Why a separate tokeniser?
//   Mixing character-level bookkeeping into parsing logic makes both
//   harder to read and test. After tokenisation the parser only sees
//   `Token(TokenType.plus)`, never the raw character '+'.
//
// This tokeniser handles arithmetic expressions:
//   digit-sequence    → NUMBER  (integer or floating-point)
//   + - * / ^ %      → binary operator tokens
//   ( )              → grouping tokens
//   whitespace        → silently discarded
//
// The same structure scales to full languages: add identifiers,
// keywords, and string literals — the character-scanning bookkeeping
// is identical.
//
// See also: parsers/shunting_yard.dart, parsers/recursive_descent_expr.dart

enum TokenType {
  number, plus, minus, star, slash, caret, percent,
  lparen, rparen, eof,
}

class Token {
  final TokenType type;
  final String lexeme;  // raw text that produced this token
  final double? value;  // parsed value for NUMBER tokens, null otherwise

  const Token(this.type, this.lexeme, [this.value]);

  @override
  String toString() => value != null
      ? 'NUM(${value! == value!.floorToDouble() ? value!.toInt() : value})'
      : type.name.toUpperCase();
}

class Tokenizer {
  final String _src;
  int _pos = 0;

  Tokenizer(this._src);

  List<Token> tokenize() {
    final tokens = <Token>[];
    while (_pos < _src.length) {
      final ch = _src[_pos];
      if (ch == ' ' || ch == '\t' || ch == '\n') { _pos++; continue; }
      switch (ch) {
        case '+': tokens.add(const Token(TokenType.plus,    '+')); _pos++; break;
        case '-': tokens.add(const Token(TokenType.minus,   '-')); _pos++; break;
        case '*': tokens.add(const Token(TokenType.star,    '*')); _pos++; break;
        case '/': tokens.add(const Token(TokenType.slash,   '/')); _pos++; break;
        case '^': tokens.add(const Token(TokenType.caret,   '^')); _pos++; break;
        case '%': tokens.add(const Token(TokenType.percent, '%')); _pos++; break;
        case '(': tokens.add(const Token(TokenType.lparen,  '(')); _pos++; break;
        case ')': tokens.add(const Token(TokenType.rparen,  ')')); _pos++; break;
        default:
          if (_isDigit(ch)) {
            tokens.add(_readNumber());
          } else {
            throw FormatException('unexpected character: "$ch" at position $_pos');
          }
      }
    }
    tokens.add(const Token(TokenType.eof, ''));
    return tokens;
  }

  bool _isDigit(String ch) {
    final code = ch.codeUnitAt(0);
    return code >= 48 && code <= 57;
  }

  Token _readNumber() {
    final start = _pos;
    bool hasDot = false;
    while (_pos < _src.length) {
      final ch = _src[_pos];
      if (_isDigit(ch)) { _pos++; continue; }
      if (ch == '.' && !hasDot) { hasDot = true; _pos++; continue; }
      break;
    }
    final text = _src.substring(start, _pos);
    return Token(TokenType.number, text, double.parse(text));
  }
}

void main() {
  const exprs = [
    '3 + 4 * 2',
    '(3.5 - 1) / 2',
    '2 ^ 10 % 3',
  ];
  for (final expr in exprs) {
    final tokens = Tokenizer(expr).tokenize();
    print('$expr');
    print('  → $tokens\n');
  }
  // 3 + 4 * 2
  //   → [NUM(3), PLUS, NUM(4), STAR, NUM(2), EOF]
  //
  // (3.5 - 1) / 2
  //   → [LPAREN, NUM(3.5), MINUS, NUM(1), RPAREN, SLASH, NUM(2), EOF]
  //
  // 2 ^ 10 % 3
  //   → [NUM(2), CARET, NUM(10), PERCENT, NUM(3), EOF]
}
