part of 'sign_up_state.dart';

abstract class SignUpModel extends Equatable {
  final String username;
  final String email;
  final String password;
  final String passwordConfirmation;
  final HttpStatus httpStatus;

  const SignUpModel({
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
