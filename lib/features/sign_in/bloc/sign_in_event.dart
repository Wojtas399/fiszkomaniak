import 'package:equatable/equatable.dart';

abstract class SignInEvent extends Equatable {
  const SignInEvent();

  @override
  List<Object> get props => [];
}

class SignInEventRefresh extends SignInEvent {}

class SignInEventSubmitted extends SignInEvent {
  final String email;
  final String password;

  const SignInEventSubmitted({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

class SignInEventResetValues extends SignInEvent {}
