import 'package:bloc_test/bloc_test.dart';
import 'package:fiszkomaniak/core/auth/auth_bloc.dart';
import 'package:fiszkomaniak/features/reset_password/bloc/reset_password_bloc.dart';
import 'package:fiszkomaniak/features/reset_password/bloc/reset_password_event.dart';
import 'package:fiszkomaniak/features/reset_password/bloc/reset_password_state.dart';
import 'package:fiszkomaniak/models/http_status_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthBloc extends Mock implements AuthBloc {}

void main() {
  final AuthBloc authBloc = MockAuthBloc();
  late ResetPasswordBloc resetPasswordBloc;
  const String email = 'email@example.com';

  setUp(() {
    resetPasswordBloc = ResetPasswordBloc(authBloc: authBloc);
  });

  tearDown(() {
    reset(authBloc);
  });

  test('initial state', () {
    final ResetPasswordState state = resetPasswordBloc.state;
    expect(state.email, '');
    expect(state.isButtonDisabled, true);
    expect(state.httpStatus, const HttpStatusInitial());
  });

  blocTest(
    'email changed',
    build: () => resetPasswordBloc,
    act: (ResetPasswordBloc bloc) =>
        bloc.add(ResetPasswordEventEmailChanged(email: email)),
    expect: () => [
      const ResetPasswordState(email: email),
    ],
  );

  blocTest(
    'send, success',
    build: () => resetPasswordBloc,
    setUp: () {
      when(() => authBloc.sendPasswordResetEmail(email))
          .thenAnswer((_) async => const HttpStatusSuccess());
    },
    act: (ResetPasswordBloc bloc) => bloc.add(
      ResetPasswordEventSend(email: email),
    ),
    expect: () => [
      ResetPasswordState(httpStatus: HttpStatusSubmitting()),
      const ResetPasswordState(httpStatus: HttpStatusSuccess()),
    ],
  );

  blocTest(
    'send, failure',
    build: () => resetPasswordBloc,
    setUp: () {
      when(() => authBloc.sendPasswordResetEmail(email)).thenAnswer(
        (_) async => const HttpStatusFailure(message: 'Error...'),
      );
    },
    act: (ResetPasswordBloc bloc) => bloc.add(
      ResetPasswordEventSend(email: email),
    ),
    expect: () => [
      ResetPasswordState(httpStatus: HttpStatusSubmitting()),
      const ResetPasswordState(
        httpStatus: HttpStatusFailure(message: 'Error...'),
      ),
    ],
  );
}
