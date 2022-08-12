part of 'reset_password_bloc.dart';

class ResetPasswordState extends Equatable {
  final BlocStatus status;
  final String email;

  const ResetPasswordState({
    required this.status,
    required this.email,
  });

  @override
  List<Object> get props => [status, email];

  bool get isButtonDisabled => email.isEmpty;

  ResetPasswordState copyWith({
    BlocStatus? status,
    String? email,
  }) {
    return ResetPasswordState(
      status: status ?? const BlocStatusInProgress(),
      email: email ?? this.email,
    );
  }

  ResetPasswordState copyWithInfo(ResetPasswordInfo info) {
    return copyWith(
      status: BlocStatusComplete<ResetPasswordInfo>(info: info),
    );
  }

  ResetPasswordState copyWithError(ResetPasswordError error) {
    return copyWith(
      status: BlocStatusError<ResetPasswordError>(error: error),
    );
  }
}

enum ResetPasswordInfo { emailHasBeenSent }

enum ResetPasswordError {
  invalidEmail,
  userNotFound,
}
