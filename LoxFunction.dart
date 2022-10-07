import 'Environment.dart';
import 'Interpreter.dart';
import 'LoxCallable.dart';
import 'Stmt.dart';

class LoxFunction implements LoxCallable {
  LFunction declaration;
  LoxFunction(this.declaration);

  @override
  int arity() {
    return declaration.params.length;
  }

  @override
  Object call(Interpreter interpreter, List<Object> arguments) {
    Environment environment = new Environment(interpreter.globals);
    for (int i = 0; i < declaration.params.length; i++) {
      environment.define(declaration.params[i].lexeme, arguments[i]);
    }
    interpreter.executeBlock(declaration.body, environment);
    return this;
  }

  @override
  String toString() {
    return "<fn " + declaration.name.lexeme + ">";
  }
}
