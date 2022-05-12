part of 'password_editor_bloc.dart';

class PasswordEditorState extends Equatable {
  final String currentPassword;
  final String newPassword;
  final String newPasswordConfirmation;

  const PasswordEditorState({
    this.currentPassword = '',
    this.newPassword = '',
    this.newPasswordConfirmation = '',
  });

  @override
  List<Object> get props => [
        currentPassword,
        newPassword,
        newPasswordConfirmation,
      ];

  bool get isCurrentPasswordCorrect => currentPassword.isNotEmpty;

  bool get isNewPasswordCorrect => UserValidator.isPasswordCorrect(newPassword);

  bool get isNewPasswordConfirmationCorrect =>
      newPasswordConfirmation.isNotEmpty &&
      newPassword == newPasswordConfirmation;

  bool get isButtonDisabled =>
      !isCurrentPasswordCorrect ||
      !isNewPasswordCorrect ||
      !isNewPasswordConfirmationCorrect;

  PasswordEditorState copyWith({
    String? currentPassword,
    String? newPassword,
    String? newPasswordConfirmation,
  }) {
    return PasswordEditorState(
      currentPassword: currentPassword ?? this.currentPassword,
      newPassword: newPassword ?? this.newPassword,
      newPasswordConfirmation:
          newPasswordConfirmation ?? this.newPasswordConfirmation,
    );
  }
}

class PasswordEditorReturns extends Equatable {
  final String currentPassword;
  final String newPassword;

  const PasswordEditorReturns({
    required this.currentPassword,
    required this.newPassword,
  });

  @override
  List<Object> get props => [
        currentPassword,
        newPassword,
      ];
}
