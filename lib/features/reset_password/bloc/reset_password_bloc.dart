import 'package:bloc/bloc.dart';
import 'package:fiszkomaniak/core/auth/auth_bloc.dart';
import 'package:fiszkomaniak/features/reset_password/bloc/reset_password_event.dart';
import 'package:fiszkomaniak/features/reset_password/bloc/reset_password_state.dart';
import 'package:fiszkomaniak/models/http_status_model.dart';

class ResetPasswordBloc extends Bloc<ResetPasswordEvent, ResetPasswordState> {
  final AuthBloc authBloc;

  ResetPasswordBloc({required this.authBloc})
      : super(const ResetPasswordState()) {
    on<ResetPasswordEventEmailChanged>(
      (event, emit) => emit(state.copyWith(email: event.email)),
    );
    on<ResetPasswordEventSend>(
      (event, emit) async {
        emit(state.copyWith(httpStatus: HttpStatusSubmitting()));
        HttpStatus result = await authBloc.sendPasswordResetEmail(event.email);
        emit(state.copyWith(httpStatus: result));
      },
    );
  }
}
