import 'dart:collection';

import 'Expr.dart';
import 'Interpreter.dart';
import 'Lox.dart';
import 'ReturnException.dart';
import 'Stmt.dart';
import 'Token.dart';

class Resolver implements ExprVisitor<void>, StmtVisitor<void> {
  Interpreter interpreter;
  List<Map<String, bool>> scopes = [];

  Resolver(this.interpreter);

  void resolve(List<Stmt> statements) {
    for (Stmt statement in statements) {
      resolveStmt(statement);
    }
  }

  void resolveStmt(Stmt stmt) {
    stmt.accept(this);
  }

  void resolveExpr(Expr expr) {
    expr.accept(this);
  }

  void resolveLocal(Expr expr, Token name) {
    for (int i = scopes.length - 1; i >= 0; i--) {
      if (scopes[i].containsKey(name.lexeme)) {
        interpreter.resolve(expr, scopes.length - 1 - i);
        return;
      }
    }
  }

  void resolveFunction(LFunction function) {
    beginScope();
    for (Token param in function.params) {
      declare(param);
      define(param);
    }
    resolve(function.body);
    endScope();
  }

  void beginScope() {
    scopes.add(new HashMap<String, bool>());
  }

  void endScope() {
    scopes.removeLast();
  }

  void declare(Token name) {
    if (scopes.isEmpty) return;

    var scope = scopes.last;
    if (scope.containsKey(name.lexeme)) {
      Lox.error(name, "Already a variable with this name in this scope.");
    }

    scope[name.lexeme] = false;
  }

  void define(Token name) {
    if (scopes.isEmpty) return;
    scopes.last[name.lexeme] = true;
  }

  @override
  void visitAssignExpr(Assign expr) {
    resolveExpr(expr.value);
    resolveLocal(expr, expr.name);
  }

  @override
  void visitBinaryExpr(Binary expr) {
    resolveExpr(expr.left);
    resolveExpr(expr.right);
  }

  @override
  void visitBlockStmt(Block stmt) {
    beginScope();
    resolve(stmt.statements);
    endScope();
  }

  @override
  void visitCallExpr(Call expr) {
    resolveExpr(expr.callee);

    for (Expr argument in expr.arguments) {
      resolveExpr(argument);
    }
  }

  @override
  void visitExpressionStmt(Expression stmt) {
    resolveExpr(stmt.expression);
  }

  @override
  void visitGroupingExpr(Grouping expr) {
    resolveExpr(expr.expression);
  }

  @override
  void visitIfStmt(If stmt) {
    resolveExpr(stmt.condition);
    resolveStmt(stmt.thenBranch);
    if (stmt.elseBranch != null) {
      resolveStmt(stmt.elseBranch!);
    }
  }

  @override
  void visitLFunctionStmt(LFunction stmt) {
    declare(stmt.name);
    define(stmt.name);

    resolveFunction(stmt);
  }

  @override
  void visitLiteralExpr(Literal expr) {
    // Purposefully does nothing, since there are no identifiers to resolve
  }

  @override
  void visitLogicalExpr(Logical expr) {
    resolveExpr(expr.left);
    resolveExpr(expr.right);
  }

  @override
  void visitPrintStmt(Print stmt) {
    resolveExpr(stmt.expression);
  }

  @override
  void visitReturnStmt(Return stmt) {
    if (stmt.value != null) {
      resolveExpr(stmt.value!);
    }
  }

  @override
  void visitUnaryExpr(Unary expr) {
    resolveExpr(expr.right);
  }

  @override
  void visitVarStmt(Var stmt) {
    declare(stmt.name);
    resolveExpr(stmt.initializer);
    define(stmt.name);
    return null;
  }

  @override
  void visitVariableExpr(Variable expr) {
    if (!scopes.isEmpty && scopes.last[expr.name.lexeme] == false) {
      Lox.error(expr.name, "Can't read local variable in its own initializer.");
    }

    resolveLocal(expr, expr.name);
    return null;
  }

  @override
  void visitWhileStmt(While stmt) {
    resolveExpr(stmt.condition);
    resolveStmt(stmt.body);
  }
}

class ResolutionError implements Exception {
  String message;

  ResolutionError(this.message);
}
