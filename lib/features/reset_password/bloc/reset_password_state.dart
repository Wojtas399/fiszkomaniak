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
      status: status ?? const BlocStatusComplete(),
      email: email ?? this.email,
    );
  }

  ResetPasswordState copyWithError(ResetPasswordErrorType errorType) {
    return copyWith(
      status: BlocStatusError<ResetPasswordErrorType>(error: errorType),
    );
  }
}

enum ResetPasswordInfoType { emailHasBeenSent }

enum ResetPasswordErrorType {
  invalidEmail,
  userNotFound,
}
