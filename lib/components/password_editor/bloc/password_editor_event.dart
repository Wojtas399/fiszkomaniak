part of 'password_editor_bloc.dart';

abstract class PasswordEditorEvent {}

class PasswordEditorEventCurrentPasswordChanged extends PasswordEditorEvent {
  final String value;

  PasswordEditorEventCurrentPasswordChanged({required this.value});
}

class PasswordEditorEventNewPasswordChanged extends PasswordEditorEvent {
  final String value;

  PasswordEditorEventNewPasswordChanged({required this.value});
}

class PasswordEditorEventNewPasswordConfirmationChanged
    extends PasswordEditorEvent {
  final String value;

  PasswordEditorEventNewPasswordConfirmationChanged({required this.value});
}
