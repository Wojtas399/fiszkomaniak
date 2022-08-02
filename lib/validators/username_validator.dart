class UsernameValidator {
  static const String message =
      'Nazwa użytkownika musi zawierać co najmniej 4 znaki';

  bool isValid(String username) {
    return username.length >= 4;
  }
}
