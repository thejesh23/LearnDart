// Tree-walking interpreter — the simplest way to give an AST meaning.
// Instead of compiling to any intermediate form, `eval` recurses
// directly over the AST nodes defined in compilers/ast.dart.
//
// Why start here before compiling?
//   A tree-walker is short enough to see in one read, and it makes
//   the semantics of the language *crystal-clear* before adding the
//   indirection of bytecode. Every interpreter you've used (early
//   Ruby, CPython before bytecode, many scripting languages) worked
//   this way. The cost — revisiting the tree on every evaluation —
//   matters only for hot loops; for a teaching language it's fine.
//
// Environment model:
//   Variables are looked up in an immutable chain of `Env` frames.
//   Each `let` binding creates a new frame that wraps the outer one.
//   This naturally models *lexical scoping* without mutation:
//     let x = 1 in (let x = 2 in x) + x
//     inner x = 2, outer x = 1  → result = 3
//
// Evaluation rules:
//   Num(v)             → v
//   Var(n)             → env.lookup(n)   (error if unbound)
//   BinOp(op, l, r)   → eval(l) op eval(r)
//   Let(n, val, body)  → eval(body, env.extend(n, eval(val)))
//   If(c, t, e)        → eval(c) != 0 ? eval(t) : eval(e)
//
// See also:
//   compilers/ast.dart       — the node types
//   compilers/compiler.dart  — compiles the same AST to bytecode
//   compilers/vm.dart        — executes that bytecode

import 'ast.dart';

// Immutable linked-list environment: each frame holds one binding and
// a reference to its enclosing scope. Lookup walks the chain; no frame
// is ever mutated, so closures captured at different times see the right
// bindings automatically.
class Env {
  final String? name;
  final double? value;
  final Env? parent;

  const Env._({this.name, this.value, this.parent});
  static const empty = Env._();

  Env extend(String n, double v) => Env._(name: n, value: v, parent: this);

  double lookup(String n) {
    if (name == n) return value!;
    if (parent == null) throw StateError('unbound variable: $n');
    return parent!.lookup(n);
  }
}

/// Evaluates [expr] in environment [env] and returns a `double`.
double eval(Expr expr, [Env env = Env.empty]) => switch (expr) {
  Num(:final value)             => value,
  Var(:final name)              => env.lookup(name),
  BinOp(:final op, :final left, :final right) => switch (op) {
    '+' => eval(left, env) + eval(right, env),
    '-' => eval(left, env) - eval(right, env),
    '*' => eval(left, env) * eval(right, env),
    '/' => eval(left, env) / eval(right, env),
    _   => throw StateError('unknown operator: $op'),
  },
  Let(:final name, :final value, :final body) =>
      eval(body, env.extend(name, eval(value, env))),
  If(:final cond, :final then_, :final else_) =>
      eval(cond, env) != 0 ? eval(then_, env) : eval(else_, env),
};

void main() {
  // Helper so examples read left-to-right: source string → result.
  void run(String desc, Expr expr, [Env env = Env.empty]) {
    print('$desc  →  ${eval(expr, env)}');
  }

  // 1. Simple arithmetic
  run('3 + 4 * 2  (as AST)',
      add(num(3), mul(num(4), num(2))));          // 11.0

  // 2. Let binding — local variable
  //    let x = 10 in x * x
  run('let x = 10 in x * x',
      let('x', num(10), mul(v('x'), v('x'))));   // 100.0

  // 3. Nested let — lexical scoping
  //    let x = 1 in (let x = 2 in x) + x
  //    inner x = 2, outer x = 1 → 2 + 1 = 3
  run('let x=1 in (let x=2 in x) + x',
      let('x', num(1),
        add(let('x', num(2), v('x')),
            v('x'))));                            // 3.0

  // 4. If expression — zero is falsy
  //    if (5 - 5) then 42 else 0  → 0 (condition is zero = false)
  run('if (5-5) then 42 else 0',
      iff(sub(num(5), num(5)), num(42), num(0))); // 0.0

  // 5. Open expression evaluated with a pre-built environment
  final globalEnv = Env.empty.extend('pi', 3.14159).extend('r', 5.0);
  run('pi * r * r  (in global env)',
      mul(v('pi'), mul(v('r'), v('r'))), globalEnv); // ~78.54

  // 6. Division by zero — Dart doubles return Infinity
  run('1 / 0', div(num(1), num(0)));             // Infinity
}
