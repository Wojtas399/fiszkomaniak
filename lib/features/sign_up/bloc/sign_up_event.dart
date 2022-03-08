abstract class SignUpEvent {}

class SignUpEventUsernameChanged implements SignUpEvent {
  final String username;

  const SignUpEventUsernameChanged({required this.username});
}

class SignUpEventEmailChanged implements SignUpEvent {
  final String email;

  const SignUpEventEmailChanged({required this.email});
}

class SignUpEventPasswordChanged implements SignUpEvent {
  final String password;

  const SignUpEventPasswordChanged({required this.password});
}

class SignUpEventPasswordConfirmationChanged implements SignUpEvent {
  final String passwordConfirmation;

  const SignUpEventPasswordConfirmationChanged({
    required this.passwordConfirmation,
  });
}

class SignUpEventSubmitted implements SignUpEvent {
  final String username;
  final String email;
  final String password;
  final String passwordConfirmation;

  const SignUpEventSubmitted({
    required this.username,
    required this.email,
    required this.password,
    required this.passwordConfirmation,
  });
}
