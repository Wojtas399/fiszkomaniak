import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../validators/password_validator.dart';

part 'password_editor_state.dart';

part 'password_editor_event.dart';

class PasswordEditorBloc
    extends Bloc<PasswordEditorEvent, PasswordEditorState> {
  PasswordEditorBloc({
    required PasswordValidator passwordValidator,
  }) : super(
          PasswordEditorState(
            passwordValidator: passwordValidator,
          ),
        ) {
    on<PasswordEditorEventCurrentPasswordChanged>(_currentPasswordChanged);
    on<PasswordEditorEventNewPasswordChanged>(_newPasswordChanged);
    on<PasswordEditorEventNewPasswordConfirmationChanged>(
      _newPasswordConfirmationChanged,
    );
  }

  void _currentPasswordChanged(
    PasswordEditorEventCurrentPasswordChanged event,
    Emitter<PasswordEditorState> emit,
  ) {
    emit(state.copyWith(currentPassword: event.value));
  }

  void _newPasswordChanged(
    PasswordEditorEventNewPasswordChanged event,
    Emitter<PasswordEditorState> emit,
  ) {
    emit(state.copyWith(newPassword: event.value));
  }

  void _newPasswordConfirmationChanged(
    PasswordEditorEventNewPasswordConfirmationChanged event,
    Emitter<PasswordEditorState> emit,
  ) {
    emit(state.copyWith(newPasswordConfirmation: event.value));
  }
}
