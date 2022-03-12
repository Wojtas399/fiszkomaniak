import 'package:equatable/equatable.dart';

abstract class SignUpEvent extends Equatable {
  const SignUpEvent();
}

class SignUpEventUsernameChanged extends SignUpEvent {
  final String username;

  const SignUpEventUsernameChanged({required this.username});

  @override
  List<Object> get props => [username];
}

class SignUpEventEmailChanged extends SignUpEvent {
  final String email;

  const SignUpEventEmailChanged({required this.email});

  @override
  List<Object> get props => [email];
}

class SignUpEventPasswordChanged extends SignUpEvent {
  final String password;

  const SignUpEventPasswordChanged({required this.password});

  @override
  List<Object> get props => [password];
}

class SignUpEventPasswordConfirmationChanged extends SignUpEvent {
  final String passwordConfirmation;

  const SignUpEventPasswordConfirmationChanged({
    required this.passwordConfirmation,
  });

  @override
  List<Object> get props => [passwordConfirmation];
}

class SignUpEventSubmitted extends SignUpEvent {
  final String username;
  final String email;
  final String password;

  const SignUpEventSubmitted({
    required this.username,
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [username, email, password];
}
