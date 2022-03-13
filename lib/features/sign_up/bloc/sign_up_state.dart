import 'package:fiszkomaniak/models/http_status_model.dart';
import 'package:fiszkomaniak/utils/utils.dart';
import 'package:flutter/cupertino.dart';

class SignUpState {
  final bool hasUsernameBeenEdited;
  final bool hasEmailBeenEdited;
  final bool hasPasswordBeenEdited;
  final bool hasPasswordConfirmationBeenEdited;
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordConfirmationController =
      TextEditingController();
  final HttpStatus httpStatus;

  String get username => usernameController.text;

  String get email => emailController.text;

  String get password => passwordController.text;

  bool get isCorrectUsername => usernameController.text.length >= 4;

  bool get isCorrectEmail => RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
      ).hasMatch(emailController.text);

  bool get isCorrectPassword => passwordController.text.length >= 6;

  bool get isCorrectPasswordConfirmation =>
      passwordController.text == passwordConfirmationController.text;

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
    this.hasUsernameBeenEdited = false,
    this.hasEmailBeenEdited = false,
    this.hasPasswordBeenEdited = false,
    this.hasPasswordConfirmationBeenEdited = false,
    String? username,
    String? email,
    String? password,
    String? passwordConfirmation,
    this.httpStatus = const HttpStatusInitial(),
  }) {
    usernameController.text = username ?? '';
    emailController.text = email ?? '';
    passwordController.text = password ?? '';
    passwordConfirmationController.text = passwordConfirmation ?? '';
    _setCursorsAtTheEndOfTextFieldValues();
  }

  SignUpState copyWith({
    bool? hasUsernameBeenEdited,
    bool? hasEmailBeenEdited,
    bool? hasPasswordBeenEdited,
    bool? hasPasswordConfirmationBeenEdited,
    HttpStatus? httpStatus,
  }) {
    return SignUpState(
      hasUsernameBeenEdited:
          hasUsernameBeenEdited ?? this.hasUsernameBeenEdited,
      hasEmailBeenEdited: hasEmailBeenEdited ?? this.hasEmailBeenEdited,
      hasPasswordBeenEdited:
          hasPasswordBeenEdited ?? this.hasPasswordBeenEdited,
      hasPasswordConfirmationBeenEdited: hasPasswordConfirmationBeenEdited ??
          this.hasPasswordConfirmationBeenEdited,
      username: usernameController.text,
      email: emailController.text,
      password: passwordController.text,
      passwordConfirmation: passwordConfirmationController.text,
      httpStatus: httpStatus ?? const HttpStatusInitial(),
    );
  }

  void _setCursorsAtTheEndOfTextFieldValues() {
    Utils.setCursorAtTheEndOfValueInsideTextField(usernameController);
    Utils.setCursorAtTheEndOfValueInsideTextField(emailController);
    Utils.setCursorAtTheEndOfValueInsideTextField(passwordController);
    Utils.setCursorAtTheEndOfValueInsideTextField(
      passwordConfirmationController,
    );
  }
}
