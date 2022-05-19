import 'package:equatable/equatable.dart';

class SignInState extends Equatable {
  final String email;
  final String password;

  bool get isButtonDisabled => email.isEmpty || password.isEmpty;

  const SignInState({
    this.email = '',
    this.password = '',
  });

  SignInState copyWith({
    String? email,
    String? password,
  }) {
    return SignInState(
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }

  @override
  List<Object> get props => [
        email,
        password,
      ];
}
