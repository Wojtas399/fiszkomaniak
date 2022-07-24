import 'package:bloc_test/bloc_test.dart';
import 'package:fiszkomaniak/domain/use_cases/auth/send_password_reset_email_use_case.dart';
import 'package:fiszkomaniak/exceptions/auth_exceptions.dart';
import 'package:fiszkomaniak/features/reset_password/bloc/reset_password_bloc.dart';
import 'package:fiszkomaniak/models/bloc_status.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockSendPasswordResetEmailUseCase extends Mock
    implements SendPasswordResetEmailUseCase {}

void main() {
  final sendPasswordResetEmailUseCase = MockSendPasswordResetEmailUseCase();

  ResetPasswordBloc createBloc({
    String email = '',
  }) {
    return ResetPasswordBloc(
      sendPasswordResetEmailUseCase: sendPasswordResetEmailUseCase,
      email: email,
    );
  }

  ResetPasswordState createState({
    BlocStatus status = const BlocStatusComplete(),
    String email = '',
  }) {
    return ResetPasswordState(
      status: status,
      email: email,
    );
  }

  tearDown(() {
    reset(sendPasswordResetEmailUseCase);
  });

  blocTest(
    'email changed, should update email in state',
    build: () => createBloc(),
    act: (ResetPasswordBloc bloc) {
      bloc.add(
        ResetPasswordEventEmailChanged(email: 'email'),
      );
    },
    expect: () => [
      createState(email: 'email'),
    ],
  );

  blocTest(
    'submit, should call use case responsible for sending password reset email',
    build: () => createBloc(email: 'email@example.com'),
    setUp: () {
      when(
        () => sendPasswordResetEmailUseCase.execute(email: 'email@example.com'),
      ).thenAnswer((_) async => '');
    },
    act: (ResetPasswordBloc bloc) {
      bloc.add(ResetPasswordEventSubmit());
    },
    expect: () => [
      createState(
        status: const BlocStatusLoading(),
        email: 'email@example.com',
      ),
      createState(
        status: const BlocStatusComplete<ResetPasswordInfoType>(
          info: ResetPasswordInfoType.emailHasBeenSent,
        ),
        email: 'email@example.com',
      ),
    ],
    verify: (_) {
      verify(
        () => sendPasswordResetEmailUseCase.execute(email: 'email@example.com'),
      ).called(1);
    },
  );

  blocTest(
    'submit, should not call use case responsible for sending password reset email if email is not correct',
    build: () => createBloc(email: 'email'),
    setUp: () {
      when(
        () => sendPasswordResetEmailUseCase.execute(email: 'email'),
      ).thenAnswer((_) async => '');
    },
    act: (ResetPasswordBloc bloc) {
      bloc.add(ResetPasswordEventSubmit());
    },
    expect: () => [
      createState(
        status: const BlocStatusError(
          errorType: ResetPasswordErrorType.invalidEmail,
        ),
        email: 'email',
      ),
    ],
    verify: (_) {
      verifyNever(() => sendPasswordResetEmailUseCase.execute(email: 'email'));
    },
  );

  blocTest(
    'submit, should emit user not found error if send password reset email use case throw it',
    build: () => createBloc(email: 'email@example.com'),
    setUp: () {
      when(
        () => sendPasswordResetEmailUseCase.execute(
          email: 'email@example.com',
        ),
      ).thenThrow(AuthException.userNotFound);
    },
    act: (ResetPasswordBloc bloc) {
      bloc.add(ResetPasswordEventSubmit());
    },
    expect: () => [
      createState(
        status: const BlocStatusLoading(),
        email: 'email@example.com',
      ),
      createState(
        status: const BlocStatusError(
          errorType: ResetPasswordErrorType.userNotFound,
        ),
        email: 'email@example.com',
      ),
    ],
    verify: (_) {
      verify(
        () => sendPasswordResetEmailUseCase.execute(
          email: 'email@example.com',
        ),
      ).called(1);
    },
  );
}
