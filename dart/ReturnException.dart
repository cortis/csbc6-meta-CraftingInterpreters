class ReturnException implements Exception {
  Object? value;

  ReturnException(this.value);
}
