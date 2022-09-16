import 'dart:io';

void main(List<String> args) {
	if (args.length != 1) {
		print("Usage: generateAST <output directory>");
		exit(64);
	}

  String outputDir = args[0];
  defineAST(outputDir, "Expr", ["Token"], [
    "Assign   : Token name, Expr value",
    "Binary   : Expr left, Token operator, Expr right",
    "Grouping : Expr expression",
    "Literal  : Object? value",
    "Logical  : Expr left, Token operator, Expr right",
    "Unary    : Token operator, Expr right",
    "Variable : Token name"
  ]);

  defineAST(outputDir, "Stmt", ["Expr", "Token"], [
    "Block      : List<Stmt> statements",
    "Expression : Expr expression",
    "If         : Expr condition, Stmt thenBranch, Stmt? elseBranch",
    "Print      : Expr expression",
    "Var        : Token name, Expr initializer"
  ]);
}

void defineAST(String outputDir, String baseName, List<String> libraries,
  List<String> types) {
  String path = outputDir + "/" + baseName + ".dart";
  var writer = new File(path).openWrite();

  for (String library in libraries) {
    writer.writeln("import '" + library + ".dart';");
  }
  writer.writeln("");

  defineVisitor(writer, baseName, types);

  writer.writeln("abstract class " + baseName + "<TYPE_NAME> {");

  // The base accept() method.
  writer.writeln(indentString(1) + "TYPE_NAME accept(" + visitorName(baseName) + "<TYPE_NAME> visitor);");

  writer.writeln("}\n");

  // The AST classes.
  for (String type in types) {
    String className = type.split(":")[0].trim();
    String fields = type.split(":")[1].trim();
    defineType(writer, baseName, className, fields);
  }

  writer.close();
}

String visitorName(String baseName) {
  return (baseName + "Visitor");
}

void defineVisitor(IOSink writer, String baseName, List<String> types) {
  writer.writeln("abstract class " + visitorName(baseName) + "<TYPE_NAME> {");

  for (String type in types) {
    String typeName = type.split(":")[0].trim();
    writer.writeln(indentString(1) + "TYPE_NAME visit" + typeName + baseName + "(" +
      typeName + " " + baseName.toLowerCase() + ");");
  }

  writer.writeln("}\n");
}

void defineType(IOSink writer, String baseName, String className, String fieldList) {
  writer.writeln("class " + className + "<TYPE_NAME> extends " + baseName + "<TYPE_NAME> {");

  // Constructor.
  writer.writeln(indentString(1) + className + "(" + fieldList + ") : ");

  // Write field initializers.
  List<String> fields = fieldList.split(", ");
  int fieldsCount = fields.length;
  for (int i = 0; i < fieldsCount; i++) {
    String field = fields[i];
    String name = field.split(" ")[1];
    String optionalComma = (i < fieldsCount - 1) ? "," : "";
    writer.writeln(indentString(2) + "this." + name + " = " + name + optionalComma);
  }

  writer.writeln(indentString(1) + "{}");

  // Visitor pattern.
  writer.writeln();
  writer.writeln(indentString(1) + "TYPE_NAME accept(" + visitorName(baseName) + "<TYPE_NAME> visitor) {");
  writer.writeln(indentString(2) + "return visitor.visit" + className + baseName + "(this);");
  writer.writeln(indentString(1) + "}");

  // Fields.
  writer.writeln();
  for (String field in fields) {
    writer.writeln(indentString(1) + field + ";");
  }

  writer.writeln("}\n");
}

String indentString(int indentLevel) {
  String result = "";
  for (int i = 0; i < indentLevel; i++) {
    result += "  ";
  }
  return result;
}
