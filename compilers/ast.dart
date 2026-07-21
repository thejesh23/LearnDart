// Abstract Syntax Tree (AST) — the data structure that sits between
// a parser and everything downstream (interpreter, type-checker,
// compiler, optimiser). Instead of working on raw text or tokens,
// each pass operates on a tree of typed nodes that mirror the
// grammatical structure of the source program.
//
// This file defines the node types for a small expression language:
//
//   expr  =  number                      (literal)
//          | identifier                  (variable reference)
//          | expr op expr                (binary operation)
//          | let id = expr in expr       (local binding)
//          | if expr then expr else expr (conditional)
//
// Implementation using Dart 3 *sealed classes*:
//   Every case is a subclass of the sealed `Expr` class. The Dart
//   compiler then enforces exhaustive `switch` matching — if you add
//   a new node type but forget to handle it somewhere, you get a
//   compile-time error, not a silent runtime crash. This is the Dart
//   equivalent of Haskell's algebraic data types or Rust's enums.
//
// The same AST is shared by:
//   compilers/interpreter.dart — tree-walking evaluator
//   compilers/compiler.dart    — bytecode compiler
//   compilers/vm.dart          — stack-based virtual machine

sealed class Expr {
  // Common pretty-printer: builds a parenthesised S-expression so you
  // can inspect the tree structure at a glance without a debugger.
  String toSExpr();
}

/// Floating-point literal: `3`, `2.5`.
class Num extends Expr {
  final double value;
  Num(this.value);

  @override
  String toSExpr() =>
      value == value.floorToDouble() ? value.toInt().toString() : value.toString();
}

/// Variable reference: `x`, `total`.
class Var extends Expr {
  final String name;
  Var(this.name);

  @override
  String toSExpr() => name;
}

/// Binary operation: `left op right`.
/// [op] is one of `+`, `-`, `*`, `/`.
class BinOp extends Expr {
  final String op;
  final Expr left, right;
  BinOp(this.op, this.left, this.right);

  @override
  String toSExpr() => '(${left.toSExpr()} $op ${right.toSExpr()})';
}

/// Local variable binding: `let name = value in body`.
/// The binding is lexically scoped — `name` is visible only within `body`.
class Let extends Expr {
  final String name;
  final Expr value;
  final Expr body;
  Let(this.name, this.value, this.body);

  @override
  String toSExpr() => '(let $name = ${value.toSExpr()} in ${body.toSExpr()})';
}

/// Conditional: `if cond then then_ else else_`.
/// Both branches must be expressions (they produce values, not statements).
class If extends Expr {
  final Expr cond;
  final Expr then_, else_;
  If(this.cond, this.then_, this.else_);

  @override
  // Zero is falsy; any non-zero value is truthy (matches our interpreter).
  String toSExpr() =>
      '(if ${cond.toSExpr()} then ${then_.toSExpr()} else ${else_.toSExpr()})';
}

// ----- helper constructors (makes building test ASTs readable) ----------

Expr num(double v) => Num(v);
Expr v(String n)   => Var(n);
Expr add(Expr l, Expr r) => BinOp('+', l, r);
Expr sub(Expr l, Expr r) => BinOp('-', l, r);
Expr mul(Expr l, Expr r) => BinOp('*', l, r);
Expr div(Expr l, Expr r) => BinOp('/', l, r);
Expr let(String n, Expr val, Expr body) => Let(n, val, body);
Expr iff(Expr c, Expr t, Expr e) => If(c, t, e);

void main() {
  // Build: let x = 6 in let y = 7 in x * y
  final tree = let('x', num(6), let('y', num(7), mul(v('x'), v('y'))));
  print('S-expr: ${tree.toSExpr()}');
  // (let x = 6 in (let y = 7 in (x * y)))

  // Build: if (10 - 10) then 1 else 2   → branch on zero
  final cond = iff(sub(num(10), num(10)), num(1), num(2));
  print('S-expr: ${cond.toSExpr()}');
  // (if (10 - 10) then 1 else 2)

  // Demonstrate exhaustive switch — compiler warns if a case is missing.
  void describe(Expr e) {
    final kind = switch (e) {
      Num()   => 'literal',
      Var()   => 'variable',
      BinOp() => 'binary op',
      Let()   => 'let binding',
      If()    => 'conditional',
    };
    print('${e.toSExpr()}  is a  $kind');
  }

  for (final e in [num(42), v('n'), add(num(1), num(2)), tree, cond]) {
    describe(e);
  }
}
