import 'package:fiszkomaniak/core/auth/auth_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ResetPasswordCubit extends Cubit<String> {
  late final AuthBloc _authBloc;

  ResetPasswordCubit({required AuthBloc authBloc}) : super('') {
    _authBloc = authBloc;
  }

  bool get isButtonDisabled => state.isEmpty;

  void emailChanged(String value) => emit(value);

  void submit() {
    if (state.isNotEmpty) {
      _authBloc.add(AuthEventSendPasswordResetEmail(email: state));
    }
  }
}
