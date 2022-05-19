class UserValidator {
  static String get incorrectUsernameMessage =>
      'Nazwa użytkownika musi zawierać co najmniej 4 znaki';

  static String get incorrectEmailMessage => 'Niepoprawny adres email';

  static String get incorrectPasswordMessage =>
      'Hasło musi zawierać co najmniej 6 znaków';

  static bool isUsernameCorrect(String username) {
    return username.length >= 4;
  }

  static bool isEmailCorrect(String email) {
    return RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
    ).hasMatch(email);
  }

  static bool isPasswordCorrect(String password) {
    return password.length >= 6;
  }
}
