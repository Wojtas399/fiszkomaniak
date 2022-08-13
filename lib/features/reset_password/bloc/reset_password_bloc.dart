import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/use_cases/auth/send_password_reset_email_use_case.dart';
import '../../../exceptions/auth_exceptions.dart';
import '../../../models/bloc_status.dart';
import '../../../validators/email_validator.dart';

part 'reset_password_event.dart';

part 'reset_password_state.dart';

class ResetPasswordBloc extends Bloc<ResetPasswordEvent, ResetPasswordState> {
  late final SendPasswordResetEmailUseCase _sendPasswordResetEmailUseCase;
  late final EmailValidator _emailValidator;

  ResetPasswordBloc({
    required SendPasswordResetEmailUseCase sendPasswordResetEmailUseCase,
    required EmailValidator emailValidator,
    BlocStatus status = const BlocStatusInitial(),
    String email = '',
  }) : super(
          ResetPasswordState(
            status: status,
            email: email,
          ),
        ) {
    _sendPasswordResetEmailUseCase = sendPasswordResetEmailUseCase;
    _emailValidator = emailValidator;
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
    if (!_emailValidator.isValid(state.email)) {
      emit(state.copyWithError(
        ResetPasswordError.invalidEmail,
      ));
    } else {
      try {
        emit(state.copyWith(
          status: const BlocStatusLoading(),
        ));
        await _sendPasswordResetEmailUseCase.execute(email: state.email);
        emit(state.copyWithInfo(
          ResetPasswordInfo.emailHasBeenSent,
        ));
      } on AuthException catch (exception) {
        if (exception == AuthException.userNotFound) {
          emit(state.copyWithError(
            ResetPasswordError.userNotFound,
          ));
        }
      }
    }
  }
}
