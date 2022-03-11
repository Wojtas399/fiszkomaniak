abstract class SignInEvent {}

class SignInEventEmailChanged implements SignInEvent {
  final String email;

  const SignInEventEmailChanged({required this.email});
}

class SignInEventPasswordChanged implements SignInEvent {
  final String password;

  const SignInEventPasswordChanged({required this.password});
}

class SignInEventSubmitted implements SignInEvent {
  final String email;
  final String password;

  const SignInEventSubmitted({required this.email, required this.password});
}
