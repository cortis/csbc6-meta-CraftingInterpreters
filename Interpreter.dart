import 'Environment.dart';
import 'Expr.dart';
import 'Lox.dart';
import 'RuntimeError.dart';
import 'Stmt.dart';
import 'Token.dart';

class Interpreter implements ExprVisitor<Object>, StmtVisitor<void> {
  Environment environment = new Environment();

  void interpret(List<Stmt> statements) {
    try {
      for (Stmt statement in statements) {
        execute(statement);
      }
    } catch (error) {
      if (error is RuntimeError) {
        Lox.runtimeError(error);
      }
    }
  }

  @override
  Object visitBinaryExpr(Binary expr) {
    Object left = evaluate(expr.left);
    Object right = evaluate(expr.right);

    switch (expr.operator.type) {
      case TokenType.BANG_EQUAL:
        return !isEqual(left, right);
      case TokenType.EQUAL_EQUAL:
        return isEqual(left, right);
      case TokenType.GREATER:
        checkNumberOperands(expr.operator, left, right);
        return (left as double) > (right as double);
      case TokenType.GREATER_EQUAL:
        checkNumberOperands(expr.operator, left, right);
        return (left as double) >= (right as double);
      case TokenType.LESS:
        checkNumberOperands(expr.operator, left, right);
        return (left as double) < (right as double);
      case TokenType.LESS_EQUAL:
        checkNumberOperands(expr.operator, left, right);
        return (left as double) <= (right as double);
      case TokenType.MINUS:
        checkNumberOperands(expr.operator, left, right);
        return (left as double) - (right as double);
      case TokenType.PLUS:
        if ((left is double) && (right is double)) {
          return (left + right);
        }
        if ((left is String) && (right is String)) {
          return (left + right);
        }

        throw new RuntimeError(
            expr.operator, "Operands must be two numbers or two strings.");
      case TokenType.SLASH:
        checkNumberOperands(expr.operator, left, right);
        return (left as double) / (right as double);
      case TokenType.STAR:
        checkNumberOperands(expr.operator, left, right);
        return (left as double) * (right as double);
      default:
    }

    // unreachable
    return 0.0;
  }

  void checkNumberOperand(Token operator, Object operand) {
    if (operand is double) return;
    throw new RuntimeError(operator, "Operand must be a number");
  }

  void checkNumberOperands(Token operator, Object left, Object right) {
    if (left is double && right is double) return;
    throw new RuntimeError(operator, "Operands must be numbers");
  }

  @override
  Object visitGroupingExpr(Grouping expr) {
    return evaluate(expr.expression);
  }

  @override
  Object visitLiteralExpr(Literal expr) {
    return expr.value ?? 0.0;
  }

  @override
  Object visitUnaryExpr(Unary expr) {
    Object right = evaluate(expr.right);

    switch (expr.operator.type) {
      case TokenType.BANG:
        return !isTruthy(right);
      case TokenType.MINUS:
        checkNumberOperand(expr.operator, right);
        return -(right as double);
      default:
        break;
    }

    // Unreachable
    return 0.0;
  }

  Object evaluate(Expr expr) {
    return expr.accept(this);
  }

  void execute(Stmt stmt) {
    stmt.accept(this);
  }

  @override
  void visitExpressionStmt(Expression stmt) {
    evaluate(stmt.expression);
  }

  @override
  void visitPrintStmt(Print stmt) {
    Object value = evaluate(stmt.expression);
    print(value);
  }

  bool isTruthy(Object? object) {
    if (object == null) {
      return false;
    }
    if (object is bool) {
      return object;
    }
    return true;
  }

  bool isEqual(Object? a, Object? b) {
    if (a == null && b == null) return true;
    if (a == null) return false;

    return a == b;
  }

  String stringify(Object? object) {
    if (object == null) return "nil";

    if (object is double) {
      // Get rid of extra precision when its just .0
      String text = object.toString();
      if (text.endsWith(".0")) {
        text = text.substring(0, text.length - 2);
      }
      return text;
    }

    return object.toString();
  }

    @override
  void visitVarStmt(Var stmt) {
    Object value = evaluate(stmt.initializer);
    environment.define(stmt.name.lexeme, value);
  }

  @override
  Object visitVariableExpr(Variable expr) {
    return environment.get(expr.name);
  }
}
