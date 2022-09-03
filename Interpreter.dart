import 'Expr.dart';
import 'Token.dart';

class Interpreter implements Visitor<Object> {

  void interpret(Expr expr) {
    try {
      Object value = evaluate(expr);
      print(stringify(value));
    } catch (error) {
      print("runtime error");
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
        return (left as double) > (right as double);
      case TokenType.GREATER_EQUAL:
        return (left as double) >= (right as double);
      case TokenType.LESS:
        return (left as double) < (right as double);
      case TokenType.LESS_EQUAL:
        return (left as double) <= (right as double);
      case TokenType.MINUS:
        return (left as double) - (right as double);
      case TokenType.PLUS:
        if ((left is double) && (right is double)) {
          return (left + right);
        }
        if ((left is String) && (right is String)) {
          return (left + right);
        }
        break;
      case TokenType.SLASH:
        return (left as double) / (right as double);
      case TokenType.STAR:
        return (left as double) * (right as double);
      default:
    }

    // unreachable
    return 0.0;
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
}
