import '../token.dart';

abstract class Expr {}

class Binary extends Expr {
  Binary(Expr left, Token operator, Expr right) :
    this.left = left,
    this.operator = operator,
    this.right = right
  {}

  Expr left;
  Token operator;
  Expr right;
}

class Grouping extends Expr {
  Grouping(Expr expression) :
    this.expression = expression
  {}

  Expr expression;
}

class Literal extends Expr {
  Literal(Object value) :
    this.value = value
  {}

  Object value;
}

class Unary extends Expr {
  Unary(Token operator, Expr right) :
    this.operator = operator,
    this.right = right
  {}

  Token operator;
  Expr right;
}
