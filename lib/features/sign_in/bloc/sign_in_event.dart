import 'package:equatable/equatable.dart';

abstract class SignInEvent extends Equatable {
  const SignInEvent();
}

class SignInEventEmailChanged extends SignInEvent {
  final String email;

  const SignInEventEmailChanged({required this.email});

  @override
  List<Object> get props => [email];
}

class SignInEventPasswordChanged extends SignInEvent {
  final String password;

  const SignInEventPasswordChanged({required this.password});

  @override
  List<Object> get props => [password];
}

class SignInEventSubmitted extends SignInEvent {
  final String email;
  final String password;

  const SignInEventSubmitted({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}
