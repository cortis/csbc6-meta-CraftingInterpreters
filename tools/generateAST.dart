import 'dart:io';

void main(List<String> args) {
	if (args.length != 1) {
		print("Usage: generateAST <output directory>");
		exit(64);
	}

    String outputDir = args[0];
    defineAST(outputDir, "Expr", [
        "Binary   : Expr left, Token operator, Expr right",
        "Grouping : Expr expression",
        "Literal  : Object value",
        "Unary    : Token operator, Expr right"
    ]);
}

void defineAST(String outputDir, String baseName, List<String> types) {
    String path = outputDir + "/" + baseName + ".dart";
    var writer = new File(path).openWrite();

    writer.writeln("import 'token.dart';");
    writer.writeln("");
    writer.writeln("abstract class " + baseName + " {}\n");

    // The AST classes.
    for (String type in types) {
      String className = type.split(":")[0].trim();
      String fields = type.split(":")[1].trim();
      defineType(writer, baseName, className, fields);
    }

    writer.close();
}

void defineType(IOSink writer, String baseName, String className, String fieldList) {
    writer.writeln("class " + className + " extends " + baseName + " {");

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

    writer.writeln("  {}");

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
