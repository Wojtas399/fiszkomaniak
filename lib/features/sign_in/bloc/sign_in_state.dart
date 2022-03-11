import 'package:equatable/equatable.dart';
import 'package:fiszkomaniak/models/http_status_model.dart';

abstract class _SignInModel extends Equatable {
  final String email;
  final String password;
  final HttpStatus httpStatus;

  const _SignInModel({
    required this.email,
    required this.password,
    required this.httpStatus,
  });

  @override
  List<Object> get props => [
        email,
        password,
        httpStatus,
      ];
}

class SignInState extends _SignInModel {
  bool get isButtonDisabled => super.email.isEmpty || super.password.isEmpty;

  const SignInState({
    String email = '',
    String password = '',
    HttpStatus httpStatus = const HttpStatusInitial(),
  }) : super(
          email: email,
          password: password,
          httpStatus: httpStatus,
        );

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
}
