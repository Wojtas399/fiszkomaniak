import 'package:equatable/equatable.dart';
import 'package:fiszkomaniak/core/validators/user_validator.dart';
import 'package:fiszkomaniak/models/http_status_model.dart';

class SignUpState extends Equatable {
  final String username;
  final String email;
  final String password;
  final String passwordConfirmation;
  final bool hasUsernameBeenEdited;
  final bool hasEmailBeenEdited;
  final bool hasPasswordBeenEdited;
  final bool hasPasswordConfirmationBeenEdited;
  final HttpStatus httpStatus;

  bool get isCorrectUsername => UserValidator.isUsernameCorrect(username);

  bool get isCorrectEmail => UserValidator.isEmailCorrect(email);

  bool get isCorrectPassword => UserValidator.isPasswordCorrect(password);

  bool get isCorrectPasswordConfirmation => password == passwordConfirmation;

  bool get isDisabledButton =>
      !isCorrectUsername ||
      !isCorrectEmail ||
      !isCorrectPassword ||
      !isCorrectPasswordConfirmation;

  String get incorrectUsernameMessage => UserValidator.incorrectUsernameMessage;

  String get incorrectEmailMessage => UserValidator.incorrectEmailMessage;

  String get incorrectPasswordMessage => UserValidator.incorrectPasswordMessage;

  String get incorrectPasswordConfirmationMessage => 'Hasła nie sa jednakowe';

  const SignUpState({
    this.username = '',
    this.email = '',
    this.password = '',
    this.passwordConfirmation = '',
    this.hasUsernameBeenEdited = false,
    this.hasEmailBeenEdited = false,
    this.hasPasswordBeenEdited = false,
    this.hasPasswordConfirmationBeenEdited = false,
    this.httpStatus = const HttpStatusInitial(),
  });

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
