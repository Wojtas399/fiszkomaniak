import 'package:equatable/equatable.dart';
import 'package:fiszkomaniak/models/http_status_model.dart';

abstract class _SignUpModel extends Equatable {
  final String username;
  final String email;
  final String password;
  final String passwordConfirmation;

  const _SignUpModel({
    required this.username,
    required this.email,
    required this.password,
    required this.passwordConfirmation,
  });
}

class SignUpState extends _SignUpModel {
  final bool hasUsernameBeenEdited;
  final bool hasEmailBeenEdited;
  final bool hasPasswordBeenEdited;
  final bool hasPasswordConfirmationBeenEdited;
  final HttpStatus httpStatus;

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

  const SignUpState({
    String username = '',
    String email = '',
    String password = '',
    String passwordConfirmation = '',
    this.hasUsernameBeenEdited = false,
    this.hasEmailBeenEdited = false,
    this.hasPasswordBeenEdited = false,
    this.hasPasswordConfirmationBeenEdited = false,
    this.httpStatus = const HttpStatusInitial(),
  }) : super(
          username: username,
          email: email,
          password: password,
          passwordConfirmation: passwordConfirmation,
        );

  SignUpState copyWith({
    String? username,
    String? email,
    String? password,
    String? passwordConfirmation,
    HttpStatus? httpStatus,
  }) {
    return SignUpState(
      hasUsernameBeenEdited: username != null ? true : hasUsernameBeenEdited,
      hasEmailBeenEdited: email != null ? true : hasEmailBeenEdited,
      hasPasswordBeenEdited: password != null ? true : hasPasswordBeenEdited,
      hasPasswordConfirmationBeenEdited: passwordConfirmation != null
          ? true
          : hasPasswordConfirmationBeenEdited,
      username: username ?? this.username,
      email: email ?? this.email,
      password: password ?? this.password,
      passwordConfirmation: passwordConfirmation ?? this.passwordConfirmation,
      httpStatus: httpStatus ?? const HttpStatusInitial(),
    );
  }

  @override
  List<Object> get props => [
        username,
        email,
        password,
        passwordConfirmation,
        hasUsernameBeenEdited,
        hasEmailBeenEdited,
        hasPasswordBeenEdited,
        hasPasswordConfirmationBeenEdited,
        httpStatus,
      ];
}
