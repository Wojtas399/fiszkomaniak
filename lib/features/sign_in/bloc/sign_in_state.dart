part of 'sign_in_bloc.dart';

class SignInState extends Equatable {
  final BlocStatus status;
  final String email;
  final String password;

  const SignInState({
    required this.status,
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [
        status,
        email,
        password,
      ];

  bool get isButtonDisabled => email.isEmpty || password.isEmpty;

  SignInState copyWith({
    BlocStatus? status,
    String? email,
    String? password,
  }) {
    return SignInState(
      status: status ?? const BlocStatusInProgress(),
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }

  SignInState copyWithInfo(SignInInfo info) {
    return copyWith(
      status: BlocStatusComplete<SignInInfo>(info: info),
    );
  }

  SignInState copyWithError(SignInError error) {
    return copyWith(
      status: BlocStatusError<SignInError>(error: error),
    );
  }
}

enum SignInInfo {
  userHasBeenSignedIn,
}

enum SignInError {
  userNotFound,
  invalidEmail,
  wrongPassword,
}
