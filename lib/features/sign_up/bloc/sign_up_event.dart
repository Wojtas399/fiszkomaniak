import 'package:equatable/equatable.dart';

abstract class SignUpEvent extends Equatable {
  const SignUpEvent();

  @override
  List<Object> get props => [];
}

class SignUpEventStartUsernameEditing extends SignUpEvent {}

class SignUpEventStartEmailEditing extends SignUpEvent {}

class SignUpEventStartPasswordEditing extends SignUpEvent {}

class SignUpEventStartPasswordConfirmationEditing extends SignUpEvent {}

class SignUpEventRefresh extends SignUpEvent {}

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

class SignUpEventResetValues extends SignUpEvent {}
