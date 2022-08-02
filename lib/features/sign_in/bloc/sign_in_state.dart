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

  SignInState copyWithError(SignInErrorType errorType) {
    return copyWith(
      status: BlocStatusError<SignInErrorType>(errorType: errorType),
    );
  }
}

enum SignInInfoType {
  userHasBeenSignedIn,
}

enum SignInErrorType {
  userNotFound,
  invalidEmail,
  wrongPassword,
}
