part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class AuthEventInitialize extends AuthEvent {}

class AuthEventLoggedUserStatusChanged extends AuthEvent {
  final bool isLoggedUser;

  AuthEventLoggedUserStatusChanged({required this.isLoggedUser});

  @override
  List<Object> get props => [isLoggedUser];
}

class AuthEventSignIn extends AuthEvent {
  final String email;
  final String password;

  AuthEventSignIn({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

class AuthEventSignUp extends AuthEvent {
  final String username;
  final String email;
  final String password;

  AuthEventSignUp({
    required this.username,
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [username, email, password];
}

class AuthEventSendPasswordResetEmail extends AuthEvent {
  final String email;

  AuthEventSendPasswordResetEmail({required this.email});

  @override
  List<Object> get props => [email];
}

class AuthEventChangePassword extends AuthEvent {
  final String currentPassword;
  final String newPassword;

  AuthEventChangePassword({
    required this.currentPassword,
    required this.newPassword,
  });

  @override
  List<Object> get props => [
        currentPassword,
        newPassword,
      ];
}
