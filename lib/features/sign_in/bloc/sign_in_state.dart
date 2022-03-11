abstract class _SignInModel {
  final String email;
  final String password;

  const _SignInModel({required this.email, required this.password});
}

class SignInState extends _SignInModel {
  const SignInState({String email = '', String password = ''})
      : super(email: email, password: password);

  SignInState copyWith({
    String? email,
    String? password,
  }) {
    return SignInState(
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }
}
