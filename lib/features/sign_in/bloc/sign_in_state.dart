import 'package:fiszkomaniak/models/http_status_model.dart';
import 'package:fiszkomaniak/utils/utils.dart';
import 'package:flutter/material.dart';

class SignInState {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final HttpStatus httpStatus;

  String get email => emailController.text;

  String get password => passwordController.text;

  bool get isButtonDisabled =>
      emailController.text.isEmpty || passwordController.text.isEmpty;

  SignInState({
    String? email,
    String? password,
    this.httpStatus = const HttpStatusInitial(),
  }) {
    emailController.text = email ?? '';
    passwordController.text = password ?? '';
    _setCursorsAtTheEndOfTextFieldValues();
  }

  SignInState copyWithHttpStatus(HttpStatus? httpStatus) {
    return SignInState(
      email: emailController.text,
      password: passwordController.text,
      httpStatus: httpStatus ?? const HttpStatusInitial(),
    );
  }

  void _setCursorsAtTheEndOfTextFieldValues() {
    Utils.setCursorAtTheEndOfValueInsideTextField(emailController);
    Utils.setCursorAtTheEndOfValueInsideTextField(passwordController);
  }
}
