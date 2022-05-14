import 'package:equatable/equatable.dart';
import 'package:fiszkomaniak/core/validators/user_validator.dart';

class SignUpState extends Equatable {
  final String username;
  final String email;
  final String password;
  final String passwordConfirmation;

  const SignUpState({
    this.username = '',
    this.email = '',
    this.password = '',
    this.passwordConfirmation = '',
  });

  @override
  List<Object> get props => [
        username,
        email,
        password,
        passwordConfirmation,
      ];

  bool get isCorrectUsername => UserValidator.isUsernameCorrect(username);

  bool get isCorrectEmail => UserValidator.isEmailCorrect(email);

  bool get isCorrectPassword => UserValidator.isPasswordCorrect(password);

  bool get isCorrectPasswordConfirmation => password == passwordConfirmation;

  bool get isDisabledButton =>
      !isCorrectUsername ||
      !isCorrectEmail ||
      !isCorrectPassword ||
      !isCorrectPasswordConfirmation;

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
