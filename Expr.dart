import 'Token.dart';

abstract class ExprVisitor<TYPE_NAME> {
  TYPE_NAME visitBinaryExpr(Binary expr);
  TYPE_NAME visitGroupingExpr(Grouping expr);
  TYPE_NAME visitLiteralExpr(Literal expr);
  TYPE_NAME visitUnaryExpr(Unary expr);
}

abstract class Expr<TYPE_NAME> {
  TYPE_NAME accept(ExprVisitor<TYPE_NAME> visitor);
}

class Binary<TYPE_NAME> extends Expr<TYPE_NAME> {
  Binary(Expr left, Token operator, Expr right) : 
    this.left = left,
    this.operator = operator,
    this.right = right
  {}

  TYPE_NAME accept(ExprVisitor<TYPE_NAME> visitor) {
    return visitor.visitBinaryExpr(this);
  }

  Expr left;
  Token operator;
  Expr right;
}

class Grouping<TYPE_NAME> extends Expr<TYPE_NAME> {
  Grouping(Expr expression) : 
    this.expression = expression
  {}

  TYPE_NAME accept(ExprVisitor<TYPE_NAME> visitor) {
    return visitor.visitGroupingExpr(this);
  }

  Expr expression;
}

class Literal<TYPE_NAME> extends Expr<TYPE_NAME> {
  Literal(Object? value) : 
    this.value = value
  {}

  TYPE_NAME accept(ExprVisitor<TYPE_NAME> visitor) {
    return visitor.visitLiteralExpr(this);
  }

  Object? value;
}

class Unary<TYPE_NAME> extends Expr<TYPE_NAME> {
  Unary(Token operator, Expr right) : 
    this.operator = operator,
    this.right = right
  {}

  TYPE_NAME accept(ExprVisitor<TYPE_NAME> visitor) {
    return visitor.visitUnaryExpr(this);
  }

  Token operator;
  Expr right;
}

