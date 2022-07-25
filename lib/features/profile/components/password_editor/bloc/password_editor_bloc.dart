import 'package:equatable/equatable.dart';
import 'package:fiszkomaniak/config/navigation.dart';
import 'package:fiszkomaniak/validators/password_validator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'password_editor_state.dart';

part 'password_editor_event.dart';

class PasswordEditorBloc
    extends Bloc<PasswordEditorEvent, PasswordEditorState> {
  late final Navigation _navigation;

  PasswordEditorBloc({
    required Navigation navigation,
    required PasswordValidator passwordValidator,
  }) : super(
          PasswordEditorState(
            passwordValidator: passwordValidator,
          ),
        ) {
    _navigation = navigation;
    on<PasswordEditorEventCurrentPasswordChanged>(_currentPasswordChanged);
    on<PasswordEditorEventNewPasswordChanged>(_newPasswordChanged);
    on<PasswordEditorEventNewPasswordConfirmationChanged>(
      _newPasswordConfirmationChanged,
    );
    on<PasswordEditorEventSubmit>(_submit);
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

  void _submit(
    PasswordEditorEventSubmit event,
    Emitter<PasswordEditorState> emit,
  ) {
    if (state.isCurrentPasswordCorrect &&
        state.isNewPasswordCorrect &&
        state.isNewPasswordConfirmationCorrect) {
      _navigation.moveBack(
        objectToReturn: PasswordEditorReturns(
          currentPassword: state.currentPassword,
          newPassword: state.newPassword,
        ),
      );
    }
  }
}
