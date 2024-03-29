import 'package:flutter_test/flutter_test.dart';
import 'package:fiszkomaniak/features/reset_password/bloc/reset_password_bloc.dart';
import 'package:fiszkomaniak/models/bloc_status.dart';

void main() {
  late ResetPasswordState state;

  setUp(
    () => state = const ResetPasswordState(
      status: BlocStatusInitial(),
      email: '',
    ),
  );

  test(
    'is button disabled, should be true if email is empty',
    () {
      expect(state.isButtonDisabled, true);
    },
  );

  test(
    'is button disabled, should be false if email is not empty',
    () {
      state = state.copyWith(email: 'email');

      expect(state.isButtonDisabled, false);
    },
  );

  test(
    'copy with status',
    () {
      const BlocStatus expectedStatus = BlocStatusLoading();

      state = state.copyWith(status: expectedStatus);
      final state2 = state.copyWith();

      expect(state.status, expectedStatus);
      expect(state2.status, const BlocStatusInProgress());
    },
  );

  test(
    'copy with email',
    () {
      const String expectedEmail = 'email@example.com';

      state = state.copyWith(email: expectedEmail);
      final state2 = state.copyWith();

      expect(state.email, expectedEmail);
      expect(state2.email, expectedEmail);
    },
  );

  test(
    'copy with info',
    () {
      const ResetPasswordInfo expectedInfo = ResetPasswordInfo.emailHasBeenSent;

      state = state.copyWithInfo(expectedInfo);

      expect(
        state.status,
        const BlocStatusComplete<ResetPasswordInfo>(info: expectedInfo),
      );
    },
  );

  test(
    'copy with error',
    () {
      const ResetPasswordError expectedError = ResetPasswordError.userNotFound;

      state = state.copyWithError(expectedError);

      expect(
        state.status,
        const BlocStatusError<ResetPasswordError>(error: expectedError),
      );
    },
  );
}
