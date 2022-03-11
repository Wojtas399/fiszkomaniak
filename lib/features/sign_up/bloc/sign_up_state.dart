import 'package:equatable/equatable.dart';
import 'package:fiszkomaniak/models/http_status_model.dart';

abstract class _SignUpModel extends Equatable {
  final String username;
  final String email;
  final String password;
  final String passwordConfirmation;
  final HttpStatus httpStatus;

  const _SignUpModel({
    required this.username,
    required this.email,
    required this.password,
    required this.passwordConfirmation,
    required this.httpStatus,
  });

  @override
  List<Object> get props => [
        username,
        email,
        password,
        passwordConfirmation,
        httpStatus,
      ];
}

class SignUpState extends _SignUpModel {
  bool get isCorrectUsername => super.username.length >= 4;

  bool get isCorrectEmail => RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
      ).hasMatch(super.email);

  bool get isCorrectPassword => super.password.length >= 6;

  bool get isCorrectPasswordConfirmation =>
      super.password == super.passwordConfirmation;

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

  const SignUpState({
    String username = '',
    String email = '',
    String password = '',
    String passwordConfirmation = '',
    HttpStatus httpStatus = const HttpStatusInitial(),
  }) : super(
          username: username,
          email: email,
          password: password,
          passwordConfirmation: passwordConfirmation,
          httpStatus: httpStatus,
        );

  SignUpState copyWith({
    String? username,
    String? email,
    String? password,
    String? passwordConfirmation,
    HttpStatus? httpStatus,
  }) {
    return SignUpState(
      username: username ?? this.username,
      email: email ?? this.email,
      password: password ?? this.password,
      passwordConfirmation: passwordConfirmation ?? this.passwordConfirmation,
      httpStatus: httpStatus ?? const HttpStatusInitial(),
    );
  }
}
