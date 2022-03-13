abstract class SignInEvent {}

class SignInEventEmailChanged extends SignInEvent {
  final String email;

  SignInEventEmailChanged({required this.email});
}

class SignInEventPasswordChanged extends SignInEvent {
  final String password;

  SignInEventPasswordChanged({required this.password});
}

class SignInEventSubmit extends SignInEvent {
  final String email;
  final String password;

  SignInEventSubmit({required this.email, required this.password});
}

class SignInEventReset extends SignInEvent {}
