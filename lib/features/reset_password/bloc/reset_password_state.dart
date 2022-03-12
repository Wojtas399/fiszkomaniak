import 'package:equatable/equatable.dart';
import 'package:fiszkomaniak/models/http_status_model.dart';

class ResetPasswordState extends Equatable {
  final String email;
  final HttpStatus httpStatus;

  const ResetPasswordState({
    this.email = '',
    this.httpStatus = const HttpStatusInitial(),
  });

  @override
  List<Object> get props => [email, httpStatus];

  ResetPasswordState copyWith({
    String? email,
    HttpStatus? httpStatus,
  }) {
    return ResetPasswordState(
      email: email ?? this.email,
      httpStatus: httpStatus ?? const HttpStatusInitial(),
    );
  }
}
