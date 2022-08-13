import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fiszkomaniak/features/sign_up/bloc/sign_up_bloc.dart';
import 'package:fiszkomaniak/models/bloc_status.dart';
import 'package:fiszkomaniak/validators/email_validator.dart';
import 'package:fiszkomaniak/validators/password_validator.dart';
import 'package:fiszkomaniak/validators/username_validator.dart';

class MockUsernameValidator extends Mock implements UsernameValidator {}

class MockEmailValidator extends Mock implements EmailValidator {}

class MockPasswordValidator extends Mock implements PasswordValidator {}

void main() {
  final usernameValidator = MockUsernameValidator();
  final emailValidator = MockEmailValidator();
  final passwordValidator = MockPasswordValidator();
  late SignUpState state;

  setUp(
    () => state = SignUpState(
      usernameValidator: usernameValidator,
      emailValidator: emailValidator,
      passwordValidator: passwordValidator,
      status: const BlocStatusInitial(),
      username: '',
      email: '',
      password: '',
      passwordConfirmation: '',
    ),
  );

  test(
    'is password confirmation valid, should be false if passwords are not the same',
    () {
      state = state.copyWith(
        password: 'password123',
        passwordConfirmation: 'password',
      );

      expect(state.isPasswordConfirmationValid, false);
    },
  );

  test(
    'is password confirmation valid, should be true if passwords are the same',
    () {
      state = state.copyWith(
        password: 'password123',
        passwordConfirmation: 'password123',
      );

      expect(state.isPasswordConfirmationValid, true);
    },
  );

  group(
    'is button disabled',
    () {
      setUp(() {
        state = state.copyWith(
          username: 'username',
          email: 'email',
          password: 'password',
          passwordConfirmation: 'password',
        );

        when(
          () => usernameValidator.isValid('username'),
        ).thenReturn(true);
        when(
          () => emailValidator.isValid('email'),
        ).thenReturn(true);
        when(
          () => passwordValidator.isValid('password'),
        ).thenReturn(true);
      });

      test(
        'is button disabled, should be false if all required values are valid',
        () {
          expect(state.isButtonDisabled, false);
        },
      );

      test(
        'is button disabled, should be true if username is not valid',
        () {
          when(
            () => usernameValidator.isValid('username'),
          ).thenReturn(false);

          expect(state.isButtonDisabled, true);
        },
      );

      test(
        'is button disabled, should be true if email is not valid',
        () {
          when(
            () => emailValidator.isValid('email'),
          ).thenReturn(false);

          expect(state.isButtonDisabled, true);
        },
      );

      test(
        'is button disabled, should be true if password is not valid',
        () {
          when(
            () => passwordValidator.isValid('password'),
          ).thenReturn(false);

          expect(state.isButtonDisabled, true);
        },
      );

      test(
        'is button disabled, should be true if passwords are not the same',
        () {
          state = state.copyWith(
            passwordConfirmation: 'password123',
          );

          expect(state.isButtonDisabled, true);
        },
      );
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
    'copy with username',
    () {
      const String expectedUsername = 'username';

      state = state.copyWith(username: expectedUsername);
      final state2 = state.copyWith();

      expect(state.username, expectedUsername);
      expect(state2.username, expectedUsername);
    },
  );

  test(
    'copy with email',
    () {
      const String expectedEmail = 'email';

      state = state.copyWith(email: expectedEmail);
      final state2 = state.copyWith();

      expect(state.email, expectedEmail);
      expect(state2.email, expectedEmail);
    },
  );

  test(
    'copy with password',
    () {
      const String expectedPassword = 'password';

      state = state.copyWith(password: expectedPassword);
      final state2 = state.copyWith();

      expect(state.password, expectedPassword);
      expect(state2.password, expectedPassword);
    },
  );

  test(
    'copy with password confirmation',
    () {
      const String expectedPasswordConfirmation = 'password';

      state = state.copyWith(
        passwordConfirmation: expectedPasswordConfirmation,
      );
      final state2 = state.copyWith();

      expect(state.passwordConfirmation, expectedPasswordConfirmation);
      expect(state2.passwordConfirmation, expectedPasswordConfirmation);
    },
  );

  test(
    'copy with info',
    () {
      const SignUpInfo expectedInfo = SignUpInfo.userHasBeenSignedUp;

      state = state.copyWithInfo(expectedInfo);

      expect(
        state.status,
        const BlocStatusComplete<SignUpInfo>(info: expectedInfo),
      );
    },
  );

  test(
    'copy with error',
    () {
      const SignUpError expectedError = SignUpError.emailAlreadyInUse;

      state = state.copyWithError(expectedError);

      expect(
        state.status,
        const BlocStatusError<SignUpError>(error: expectedError),
      );
    },
  );
}
