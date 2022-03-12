import 'package:equatable/equatable.dart';

abstract class ResetPasswordEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class ResetPasswordEventEmailChanged extends ResetPasswordEvent {
  final String email;

  ResetPasswordEventEmailChanged({required this.email});

  @override
  List<Object> get props => [email];
}

class ResetPasswordEventSend extends ResetPasswordEvent {
  final String email;

  ResetPasswordEventSend({required this.email});

  @override
  List<Object> get props => [email];
}
