import 'Token.dart';

abstract class Visitor<TYPE_NAME> {
  TYPE_NAME visitBinaryExpr(Binary expr);
  TYPE_NAME visitGroupingExpr(Grouping expr);
  TYPE_NAME visitLiteralExpr(Literal expr);
  TYPE_NAME visitUnaryExpr(Unary expr);
}

abstract class Expr {
  Expr accept(Visitor<Expr> visitor);
}

class Binary extends Expr {
  Binary(Expr left, Token operator, Expr right) : 
    this.left = left,
    this.operator = operator,
    this.right = right
  {}

  Expr accept(Visitor<Expr> visitor) {
    return visitor.visitBinaryExpr(this);
  }

  Expr left;
  Token operator;
  Expr right;
}

class Grouping extends Expr {
  Grouping(Expr expression) : 
    this.expression = expression
  {}

  Expr accept(Visitor<Expr> visitor) {
    return visitor.visitGroupingExpr(this);
  }

  Expr expression;
}

class Literal extends Expr {
  Literal(Object value) : 
    this.value = value
  {}

  Expr accept(Visitor<Expr> visitor) {
    return visitor.visitLiteralExpr(this);
  }

  Object value;
}

class Unary extends Expr {
  Unary(Token operator, Expr right) : 
    this.operator = operator,
    this.right = right
  {}

  Expr accept(Visitor<Expr> visitor) {
    return visitor.visitUnaryExpr(this);
  }

  Token operator;
  Expr right;
}

