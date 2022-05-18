part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthStateInitial extends AuthState {
  const AuthStateInitial();
}

class AuthStateLoading extends AuthState {}

class AuthStateSignedIn extends AuthState {}

class AuthStatePasswordResetEmailSent extends AuthState {}

class AuthStatePasswordChanged extends AuthState {}

class AuthStateSignedOut extends AuthState {}

class AuthStateUserNotFound extends AuthState {}

class AuthStateWrongPassword extends AuthState {}

class AuthStateInvalidEmail extends AuthState {}

class AuthStateEmailAlreadyInUse extends AuthState {}

class AuthStateError extends AuthState {
  final String message;

  const AuthStateError({required this.message});

  @override
  List<Object> get props => [message];
}
