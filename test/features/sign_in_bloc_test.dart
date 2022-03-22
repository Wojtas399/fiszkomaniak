import 'package:bloc_test/bloc_test.dart';
import 'package:fiszkomaniak/core/auth/auth_bloc.dart';
import 'package:fiszkomaniak/features/sign_in/bloc/sign_in_bloc.dart';
import 'package:fiszkomaniak/features/sign_in/bloc/sign_in_event.dart';
import 'package:fiszkomaniak/features/sign_in/bloc/sign_in_state.dart';
import 'package:fiszkomaniak/models/http_status_model.dart';
import 'package:fiszkomaniak/models/sign_in_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthBloc extends Mock implements AuthBloc {}

void main() {
  final AuthBloc authBloc = MockAuthBloc();
  late SignInBloc signInBloc;
  const SignInModel data = SignInModel(
    email: 'email@example.com',
    password: 'password123',
  );

  setUp(() {
    signInBloc = SignInBloc(authBloc: authBloc);
  });

  tearDown(() {
    reset(authBloc);
  });

  test('initial state', () {
    final SignInState state = signInBloc.state;
    expect(state.email, '');
    expect(state.password, '');
    expect(state.isButtonDisabled, true);
    expect(state.httpStatus, const HttpStatusInitial());
  });

  blocTest(
    'email changed',
    build: () => signInBloc,
    act: (SignInBloc bloc) =>
        bloc.add(SignInEventEmailChanged(email: data.email)),
    expect: () => [SignInState(email: data.email)],
  );

  blocTest(
    'password changed',
    build: () => signInBloc,
    act: (SignInBloc bloc) =>
        bloc.add(SignInEventPasswordChanged(password: data.password)),
    expect: () => [SignInState(password: data.password)],
  );

  blocTest(
    'submit, success',
    build: () => signInBloc,
    setUp: () {
      when(() => authBloc.signIn(data))
          .thenAnswer((_) async => HttpStatusSuccess());
    },
    act: (SignInBloc bloc) =>
        bloc.add(SignInEventSubmit(email: data.email, password: data.password)),
    expect: () => [
      SignInState(httpStatus: HttpStatusSubmitting()),
      SignInState(httpStatus: HttpStatusSuccess()),
    ],
  );

  blocTest(
    'submit, failure',
    build: () => signInBloc,
    setUp: () {
      when(() => authBloc.signIn(data)).thenAnswer(
        (_) async => const HttpStatusFailure(message: 'Error...'),
      );
    },
    act: (SignInBloc bloc) =>
        bloc.add(SignInEventSubmit(email: data.email, password: data.password)),
    expect: () => [
      SignInState(httpStatus: HttpStatusSubmitting()),
      const SignInState(httpStatus: HttpStatusFailure(message: 'Error...')),
    ],
  );

  blocTest(
    'reset',
    build: () => signInBloc,
    act: (SignInBloc bloc) => bloc.add(SignInEventReset()),
    expect: () => [const SignInState()],
  );
}
