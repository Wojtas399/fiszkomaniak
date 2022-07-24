import 'package:equatable/equatable.dart';
import 'package:fiszkomaniak/validators/email_validator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/use_cases/auth/send_password_reset_email_use_case.dart';
import '../../../exceptions/auth_exceptions.dart';
import '../../../models/bloc_status.dart';

part 'reset_password_event.dart';

part 'reset_password_state.dart';

class ResetPasswordBloc extends Bloc<ResetPasswordEvent, ResetPasswordState>
    with EmailValidator {
  late final SendPasswordResetEmailUseCase _sendPasswordResetEmailUseCase;

  ResetPasswordBloc({
    required SendPasswordResetEmailUseCase sendPasswordResetEmailUseCase,
    BlocStatus status = const BlocStatusInitial(),
    String email = '',
  }) : super(
          ResetPasswordState(
            status: status,
            email: email,
          ),
        ) {
    _sendPasswordResetEmailUseCase = sendPasswordResetEmailUseCase;
    on<ResetPasswordEventEmailChanged>(_emailChanged);
    on<ResetPasswordEventSubmit>(_submit);
  }

  void _emailChanged(
    ResetPasswordEventEmailChanged event,
    Emitter<ResetPasswordState> emit,
  ) {
    emit(state.copyWith(
      email: event.email,
    ));
  }

  Future<void> _submit(
    ResetPasswordEventSubmit event,
    Emitter<ResetPasswordState> emit,
  ) async {
    if (!isEmailValid(state.email)) {
      emit(state.copyWithError(ResetPasswordErrorType.invalidEmail));
    } else {
      try {
        emit(state.copyWith(status: const BlocStatusLoading()));
        await _sendPasswordResetEmailUseCase.execute(email: state.email);
        emit(state.copyWith(
          status: const BlocStatusComplete<ResetPasswordInfoType>(
            info: ResetPasswordInfoType.emailHasBeenSent,
          ),
        ));
      } on AuthException catch (exception) {
        if (exception == AuthException.userNotFound) {
          emit(state.copyWithError(ResetPasswordErrorType.userNotFound));
        }
      }
    }
  }
}
