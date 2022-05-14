import 'package:equatable/equatable.dart';

enum AuthErrorCode {
  userNotFound,
  wrongPassword,
  invalidEmail,
  emailAlreadyInUse,
}

class AuthException extends Equatable {
  final AuthErrorCode code;

  const AuthException({required this.code});

  @override
  List<Object> get props => [code];
}
