part of 'password_editor_bloc.dart';

class PasswordEditorState extends Equatable {
  late final PasswordValidator _passwordValidator;
  final String currentPassword;
  final String newPassword;
  final String newPasswordConfirmation;

  PasswordEditorState({
    required PasswordValidator passwordValidator,
    this.currentPassword = '',
    this.newPassword = '',
    this.newPasswordConfirmation = '',
  }) {
    _passwordValidator = passwordValidator;
  }

  @override
  List<Object> get props => [
        currentPassword,
        newPassword,
        newPasswordConfirmation,
      ];

  bool get isCurrentPasswordCorrect => currentPassword.isNotEmpty;

  bool get isNewPasswordCorrect => _passwordValidator.isValid(newPassword);

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
      passwordValidator: _passwordValidator,
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
