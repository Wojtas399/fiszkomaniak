import 'package:fiszkomaniak/features/profile/components/password_editor/bloc/password_editor_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late PasswordEditorState state;

  setUp(() {
    state = const PasswordEditorState();
  });

  test('initial state', () {
    expect(state.currentPassword, '');
    expect(state.newPassword, '');
    expect(state.newPasswordConfirmation, '');
  });

  test('copy with current password', () {
    const String password = 'password';

    final PasswordEditorState state2 = state.copyWith(
      currentPassword: password,
    );
    final PasswordEditorState state3 = state2.copyWith();

    expect(state2.currentPassword, password);
    expect(state3.currentPassword, password);
  });

  test('copy with new password', () {
    const String password = 'password';

    final PasswordEditorState state2 = state.copyWith(
      newPassword: password,
    );
    final PasswordEditorState state3 = state2.copyWith();

    expect(state2.newPassword, password);
    expect(state3.newPassword, password);
  });

  test('copy with new password confirmation', () {
    const String password = 'password';

    final PasswordEditorState state2 = state.copyWith(
      newPasswordConfirmation: password,
    );
    final PasswordEditorState state3 = state2.copyWith();

    expect(state2.newPasswordConfirmation, password);
    expect(state3.newPasswordConfirmation, password);
  });

  test('is current password correct, empty string', () {
    expect(state.isCurrentPasswordCorrect, false);
  });

  test('is current password correct, not empty string', () {
    state = state.copyWith(currentPassword: 'current password');

    expect(state.isCurrentPasswordCorrect, true);
  });

  test('is correct new password, empty string', () {
    expect(state.isNewPasswordCorrect, false);
  });

  test('is correct new password, length shorter than 6 letters', () {
    state = state.copyWith(newPassword: 'new');

    expect(state.isNewPasswordCorrect, false);
  });

  test('is correct new password, length longer than 6 letters', () {
    state = state.copyWith(newPassword: 'new password');

    expect(state.isNewPasswordCorrect, true);
  });

  test('is correct new password confirmation, empty string', () {
    expect(state.isNewPasswordConfirmationCorrect, false);
  });

  test(
    'is correct new password confirmation, not the same as new password',
    () {
      state = state.copyWith(
        newPassword: 'new password',
        newPasswordConfirmation: 'new',
      );

      expect(state.isNewPasswordConfirmationCorrect, false);
    },
  );

  test('is correct new password confirmation, matches to new password', () {
    state = state.copyWith(
      newPassword: 'new password',
      newPasswordConfirmation: 'new password',
    );

    expect(state.isNewPasswordConfirmationCorrect, true);
  });

  test('is button disabled, current password is incorrect', () {
    state = state.copyWith(
      newPassword: 'new password',
      newPasswordConfirmation: 'new password',
    );

    expect(state.isButtonDisabled, true);
  });

  test('is button disabled, new password is incorrect', () {
    state = state.copyWith(
      currentPassword: 'current password',
      newPassword: 'new p',
      newPasswordConfirmation: 'new password',
    );

    expect(state.isButtonDisabled, true);
  });

  test('is button disabled, new password confirmation is incorrect', () {
    state = state.copyWith(
      currentPassword: 'current password',
      newPassword: 'new password',
      newPasswordConfirmation: 'new pass',
    );

    expect(state.isButtonDisabled, true);
  });

  test('is button disabled, all values are correct', () {
    state = state.copyWith(
      currentPassword: 'current password',
      newPassword: 'new password',
      newPasswordConfirmation: 'new password',
    );

    expect(state.isButtonDisabled, false);
  });
}
