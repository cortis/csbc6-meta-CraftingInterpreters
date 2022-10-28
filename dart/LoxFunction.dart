import 'Environment.dart';
import 'Interpreter.dart';
import 'LoxCallable.dart';
import 'ReturnException.dart';
import 'Stmt.dart';

class LoxFunction implements LoxCallable {
  LFunction declaration;
  Environment closure;
  LoxFunction(this.declaration, this.closure);

  @override
  int arity() {
    return declaration.params.length;
  }

  @override
  Object call(Interpreter interpreter, List<Object> arguments) {
    Environment environment = new Environment(closure);
    for (int i = 0; i < declaration.params.length; i++) {
      environment.define(declaration.params[i].lexeme, arguments[i]);
    }
    try {
      interpreter.executeBlock(declaration.body, environment);
    } catch (returnValue) {
      if (returnValue is ReturnException) {
        return returnValue.value ?? this;
      }
    }
    return this;
  }

  @override
  String toString() {
    return "<fn " + declaration.name.lexeme + ">";
  }
}
