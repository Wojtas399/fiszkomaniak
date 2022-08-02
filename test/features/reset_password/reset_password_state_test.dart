import 'package:fiszkomaniak/features/reset_password/bloc/reset_password_bloc.dart';
import 'package:fiszkomaniak/models/bloc_status.dart';
import 'package:flutter_test/flutter_test.dart';

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
      expect(state2.status, const BlocStatusComplete());
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
    'copy with error',
    () {
      state = state.copyWithError(ResetPasswordErrorType.userNotFound);

      expect(
        state.status,
        const BlocStatusError<ResetPasswordErrorType>(
          errorType: ResetPasswordErrorType.userNotFound,
        ),
      );
    },
  );
}
