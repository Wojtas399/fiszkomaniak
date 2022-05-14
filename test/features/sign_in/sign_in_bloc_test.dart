import 'package:bloc_test/bloc_test.dart';
import 'package:fiszkomaniak/core/auth/auth_bloc.dart';
import 'package:fiszkomaniak/features/sign_in/bloc/sign_in_bloc.dart';
import 'package:fiszkomaniak/features/sign_in/bloc/sign_in_event.dart';
import 'package:fiszkomaniak/features/sign_in/bloc/sign_in_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthBloc extends Mock implements AuthBloc {}

void main() {
  final AuthBloc authBloc = MockAuthBloc();
  late SignInBloc bloc;

  setUp(() {
    bloc = SignInBloc(authBloc: authBloc);
  });

  tearDown(() {
    reset(authBloc);
  });

  blocTest(
    'email changed',
    build: () => bloc,
    act: (_) => bloc.add(
      SignInEventEmailChanged(email: 'email'),
    ),
    expect: () => [const SignInState(email: 'email')],
  );

  blocTest(
    'password changed',
    build: () => bloc,
    act: (_) => bloc.add(
      SignInEventPasswordChanged(password: 'password'),
    ),
    expect: () => [const SignInState(password: 'password')],
  );

  blocTest(
    'submit, password is empty',
    build: () => bloc,
    act: (_) {
      bloc.add(SignInEventEmailChanged(email: 'email'));
      bloc.add(SignInEventSubmit());
    },
    verify: (_) {
      verifyNever(
        () => authBloc.add(AuthEventSignIn(email: 'email', password: '')),
      );
    },
  );

  blocTest(
    'submit, email is empty',
    build: () => bloc,
    act: (_) {
      bloc.add(SignInEventPasswordChanged(password: 'password'));
      bloc.add(SignInEventSubmit());
    },
    verify: (_) {
      verifyNever(
        () => authBloc.add(AuthEventSignIn(email: '', password: 'password')),
      );
    },
  );

  blocTest(
    'submit, all values are not empty',
    build: () => bloc,
    act: (_) {
      bloc.add(SignInEventEmailChanged(email: 'email'));
      bloc.add(SignInEventPasswordChanged(password: 'password'));
      bloc.add(SignInEventSubmit());
    },
    verify: (_) {
      verify(
        () => authBloc.add(
          AuthEventSignIn(email: 'email', password: 'password'),
        ),
      ).called(1);
    },
  );

  blocTest(
    'reset',
    build: () => bloc,
    act: (_) {
      bloc.add(SignInEventEmailChanged(email: 'email'));
      bloc.add(SignInEventReset());
    },
    expect: () => [
      const SignInState(email: 'email'),
      const SignInState(),
    ],
  );
}
