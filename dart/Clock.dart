import 'Interpreter.dart';
import 'LoxCallable.dart';

class Clock implements LoxCallable {
  @override
  int arity() {
    return 0;
  }

  @override
  Object call(Interpreter interpreter, List<Object> arguments) {
    var now = DateTime.now();
    return now.microsecondsSinceEpoch / 1000.0;
  }

  @override
  String toString() {
    return "<native fn>";
  }
}
