import 'Token.dart';

abstract class ExprVisitor<TYPE_NAME> {
  TYPE_NAME visitAssignExpr(Assign expr);
  TYPE_NAME visitBinaryExpr(Binary expr);
  TYPE_NAME visitGroupingExpr(Grouping expr);
  TYPE_NAME visitLiteralExpr(Literal expr);
  TYPE_NAME visitLogicalExpr(Logical expr);
  TYPE_NAME visitUnaryExpr(Unary expr);
  TYPE_NAME visitVariableExpr(Variable expr);
}

abstract class Expr<TYPE_NAME> {
  TYPE_NAME accept(ExprVisitor<TYPE_NAME> visitor);
}

class Assign<TYPE_NAME> extends Expr<TYPE_NAME> {
  Assign(this.name, this.value);

  TYPE_NAME accept(ExprVisitor<TYPE_NAME> visitor) {
    return visitor.visitAssignExpr(this);
  }

  Token name;
  Expr value;
}

class Binary<TYPE_NAME> extends Expr<TYPE_NAME> {
  Binary(this.left, this.operator, this.right);

  TYPE_NAME accept(ExprVisitor<TYPE_NAME> visitor) {
    return visitor.visitBinaryExpr(this);
  }

  Expr left;
  Token operator;
  Expr right;
}

class Grouping<TYPE_NAME> extends Expr<TYPE_NAME> {
  Grouping(this.expression);

  TYPE_NAME accept(ExprVisitor<TYPE_NAME> visitor) {
    return visitor.visitGroupingExpr(this);
  }

  Expr expression;
}

class Literal<TYPE_NAME> extends Expr<TYPE_NAME> {
  Literal(this.value);

  TYPE_NAME accept(ExprVisitor<TYPE_NAME> visitor) {
    return visitor.visitLiteralExpr(this);
  }

  Object? value;
}

class Logical<TYPE_NAME> extends Expr<TYPE_NAME> {
  Logical(this.left, this.operator, this.right);

  TYPE_NAME accept(ExprVisitor<TYPE_NAME> visitor) {
    return visitor.visitLogicalExpr(this);
  }

  Expr left;
  Token operator;
  Expr right;
}

class Unary<TYPE_NAME> extends Expr<TYPE_NAME> {
  Unary(this.operator, this.right);

  TYPE_NAME accept(ExprVisitor<TYPE_NAME> visitor) {
    return visitor.visitUnaryExpr(this);
  }

  Token operator;
  Expr right;
}

class Variable<TYPE_NAME> extends Expr<TYPE_NAME> {
  Variable(this.name);

  TYPE_NAME accept(ExprVisitor<TYPE_NAME> visitor) {
    return visitor.visitVariableExpr(this);
  }

  Token name;
}

