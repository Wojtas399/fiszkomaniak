import 'package:bloc_test/bloc_test.dart';
import 'package:fiszkomaniak/core/auth/auth_bloc.dart';
import 'package:fiszkomaniak/features/reset_password/reset_password_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthBloc extends Mock implements AuthBloc {}

void main() {
  final AuthBloc authBloc = MockAuthBloc();
  late ResetPasswordCubit cubit;

  setUp(() {
    cubit = ResetPasswordCubit(authBloc: authBloc);
  });

  tearDown(() {
    reset(authBloc);
  });

  blocTest(
    'email changed',
    build: () => cubit,
    act: (_) => cubit.emailChanged('email'),
    expect: () => ['email'],
  );

  blocTest(
    'is button disabled, email is empty',
    build: () => cubit,
    verify: (_) {
      expect(cubit.isButtonDisabled, true);
    },
  );

  blocTest(
    'is button disabled, email is not empty',
    build: () => cubit,
    act: (_) => cubit.emailChanged('email'),
    expect: () => ['email'],
    verify: (_) {
      expect(cubit.isButtonDisabled, false);
    },
  );

  blocTest(
    'submit, email is empty',
    build: () => cubit,
    act: (_) => cubit.submit(),
    verify: (_) {
      verifyNever(
        () => authBloc.add(AuthEventSendPasswordResetEmail(email: '')),
      );
    },
  );

  blocTest(
    'submit, email is not empty',
    build: () => cubit,
    act: (_) {
      cubit.emailChanged('email');
      cubit.submit();
    },
    expect: () => ['email'],
    verify: (_) {
      verify(
        () => authBloc.add(AuthEventSendPasswordResetEmail(email: 'email')),
      ).called(1);
    },
  );
}
