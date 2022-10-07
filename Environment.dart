import 'dart:collection';

import 'Resolver.dart';
import 'RuntimeError.dart';
import 'Token.dart';

class Environment {
  final Environment? enclosing;
  final Map<String, Object> values = new HashMap();

  Environment.empty() : enclosing = null {}

  Environment(this.enclosing);

  void define(String name, Object value) {
    values[name] = value;
  }

  Object get(Token name) {
    if (values.containsKey(name.lexeme)) {
      // Note: we already ensured that values contains name.lexeme so we shouldn't ever see this defaulting to 0
      return values[name.lexeme] ?? 0;
    }

    if (enclosing != null) {
      return enclosing!.get(name);
    }

    throw new RuntimeError(name, "Undefined variable '" + name.lexeme + "'.");
  }

  Object getAt(int distance, String name) {
    var result = ancestor(distance).values[name];

    assert(result != null, throw new ResolutionError("Unresolved variable: " + name + " at expected depth: " + distance.toString()));

    return result!;
  }

  Environment ancestor(int distance) {
    Environment? environment = this;
    for (int i = 0; i < distance; i++) {
      environment = environment?.enclosing;
    }

    assert(environment != null, throw new ResolutionError("Unresolved environment ancestor at depth: " + distance.toString()));

    return environment!;
  }


  void assign(Token name, Object value) {
    if (values.containsKey(name.lexeme)) {
      values[name.lexeme] = value;
      return;
    }

    if (enclosing != null) {
      enclosing!.assign(name, value);
      return;
    }

    throw new RuntimeError(name, "Undefined variable '" + name.lexeme + "'.");
  }
}
