mixin EmailValidator {
  final String _regexpVal =
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";

  bool isEmailValid(String email) {
    return RegExp(_regexpVal).hasMatch(email);
  }
}
