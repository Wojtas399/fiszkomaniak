class PasswordValidator {
  static const String message = 'Hasło musi zawierać co najmniej 6 znaków';

  bool isValid(String password) {
    return password.length >= 6;
  }
}
