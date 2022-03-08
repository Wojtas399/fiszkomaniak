class SignUpState {
  final String username;
  final String email;
  final String password;
  final String passwordConfirmation;

  bool get isCorrectUsername => username.length >= 4;

  bool get isCorrectEmail => RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
      ).hasMatch(email);

  bool get isCorrectPassword => password.length >= 6;

  bool get isCorrectPasswordConfirmation => password == passwordConfirmation;

  bool get isDisabledButton =>
      !isCorrectUsername ||
      !isCorrectEmail ||
      !isCorrectPassword ||
      !isCorrectPasswordConfirmation;

  String get incorrectUsernameMessage =>
      'Nazwa użytkownika musi zawierać co najmniej 4 znaki';

  String get incorrectEmailMessage => 'Niepoprawny adres email';

  String get incorrectPasswordMessage =>
      'Hasło musi zawierać co najmniej 6 znaków';

  String get incorrectPasswordConfirmationMessage => 'Hasła nie sa jednakowe';

  SignUpState({
    this.username = '',
    this.email = '',
    this.password = '',
    this.passwordConfirmation = '',
  });

  SignUpState copyWith({
    String? username,
    String? email,
    String? password,
    String? passwordConfirmation,
  }) {
    return SignUpState(
      username: username ?? this.username,
      email: email ?? this.email,
      password: password ?? this.password,
      passwordConfirmation: passwordConfirmation ?? this.passwordConfirmation,
    );
  }
}
