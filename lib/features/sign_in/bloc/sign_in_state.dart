import 'package:equatable/equatable.dart';
import 'package:fiszkomaniak/models/http_status_model.dart';

class SignInState extends Equatable {
  final String email;
  final String password;
  final HttpStatus httpStatus;

  bool get isButtonDisabled => email.isEmpty || password.isEmpty;

  const SignInState({
    this.email = '',
    this.password = '',
    this.httpStatus = const HttpStatusInitial(),
  });

  SignInState copyWith({
    String? email,
    String? password,
    HttpStatus? httpStatus,
  }) {
    return SignInState(
      email: email ?? this.email,
      password: password ?? this.password,
      httpStatus: httpStatus ?? const HttpStatusInitial(),
    );
  }

  @override
  List<Object> get props => [
        email,
        password,
        httpStatus,
      ];
}
