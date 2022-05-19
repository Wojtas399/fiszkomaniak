import 'package:bloc_test/bloc_test.dart';
import 'package:fiszkomaniak/core/auth/auth_bloc.dart';
import 'package:fiszkomaniak/features/sign_up/bloc/sign_up_bloc.dart';
import 'package:fiszkomaniak/features/sign_up/bloc/sign_up_event.dart';
import 'package:fiszkomaniak/features/sign_up/bloc/sign_up_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthBloc extends Mock implements AuthBloc {}

void main() {
  final AuthBloc authBloc = MockAuthBloc();
  late SignUpBloc bloc;

  setUp(() {
    bloc = SignUpBloc(authBloc: authBloc);
  });

  tearDown(() {
    reset(authBloc);
  });

  blocTest(
    'username changed',
    build: () => bloc,
    act: (_) => bloc.add(SignUpEventUsernameChanged(username: 'username')),
    expect: () => [
      const SignUpState(username: 'username'),
    ],
  );

  blocTest(
    'email changed',
    build: () => bloc,
    act: (_) => bloc.add(SignUpEventEmailChanged(email: 'email')),
    expect: () => [const SignUpState(email: 'email')],
  );

  blocTest(
    'password changed',
    build: () => bloc,
    act: (_) => bloc.add(SignUpEventPasswordChanged(password: 'password')),
    expect: () => [const SignUpState(password: 'password')],
  );

  blocTest(
    'password confirmation changed',
    build: () => bloc,
    act: (_) => bloc.add(SignUpEventPasswordConfirmationChanged(
      passwordConfirmation: 'passwordConfirmation',
    )),
    expect: () => [
      const SignUpState(passwordConfirmation: 'passwordConfirmation'),
    ],
  );

  blocTest(
    'submit, incorrect username',
    build: () => bloc,
    act: (_) {
      bloc.add(SignUpEventUsernameChanged(username: 'use'));
      bloc.add(SignUpEventEmailChanged(email: 'email@example.com'));
      bloc.add(SignUpEventPasswordChanged(password: 'password'));
      bloc.add(SignUpEventPasswordConfirmationChanged(
        passwordConfirmation: 'password',
      ));
      bloc.add(SignUpEventSubmit());
    },
    verify: (_) {
      verifyNever(
        () => authBloc.add(AuthEventSignUp(
          username: 'use',
          email: 'email@example.com',
          password: 'password',
        )),
      );
    },
  );

  blocTest(
    'submit, incorrect email',
    build: () => bloc,
    act: (_) {
      bloc.add(SignUpEventUsernameChanged(username: 'username'));
      bloc.add(SignUpEventEmailChanged(email: 'email'));
      bloc.add(SignUpEventPasswordChanged(password: 'password'));
      bloc.add(SignUpEventPasswordConfirmationChanged(
        passwordConfirmation: 'password',
      ));
      bloc.add(SignUpEventSubmit());
    },
    verify: (_) {
      verifyNever(
        () => authBloc.add(AuthEventSignUp(
          username: 'username',
          email: 'email',
          password: 'password',
        )),
      );
    },
  );

  blocTest(
    'submit, incorrect password',
    build: () => bloc,
    act: (_) {
      bloc.add(SignUpEventUsernameChanged(username: 'username'));
      bloc.add(SignUpEventEmailChanged(email: 'email@example.com'));
      bloc.add(SignUpEventPasswordChanged(password: 'passw'));
      bloc.add(SignUpEventPasswordConfirmationChanged(
        passwordConfirmation: 'password',
      ));
      bloc.add(SignUpEventSubmit());
    },
    verify: (_) {
      verifyNever(
        () => authBloc.add(AuthEventSignUp(
          username: 'username',
          email: 'email@example.com',
          password: 'passw',
        )),
      );
    },
  );

  blocTest(
    'submit, incorrect password confirmation',
    build: () => bloc,
    act: (_) {
      bloc.add(SignUpEventUsernameChanged(username: 'username'));
      bloc.add(SignUpEventEmailChanged(email: 'email@example.com'));
      bloc.add(SignUpEventPasswordChanged(password: 'password'));
      bloc.add(SignUpEventPasswordConfirmationChanged(
        passwordConfirmation: 'password123',
      ));
      bloc.add(SignUpEventSubmit());
    },
    verify: (_) {
      verifyNever(
        () => authBloc.add(AuthEventSignUp(
          username: 'username',
          email: 'email@example.com',
          password: 'password',
        )),
      );
    },
  );

  blocTest(
    'submit, all params are correct',
    build: () => bloc,
    act: (_) {
      bloc.add(SignUpEventUsernameChanged(username: 'username'));
      bloc.add(SignUpEventEmailChanged(email: 'email@example.com'));
      bloc.add(SignUpEventPasswordChanged(password: 'password'));
      bloc.add(SignUpEventPasswordConfirmationChanged(
        passwordConfirmation: 'password',
      ));
      bloc.add(SignUpEventSubmit());
    },
    verify: (_) {
      verify(
        () => authBloc.add(AuthEventSignUp(
          username: 'username',
          email: 'email@example.com',
          password: 'password',
        )),
      ).called(1);
    },
  );

  blocTest(
    'reset',
    build: () => bloc,
    act: (_) {
      bloc.add(SignUpEventUsernameChanged(username: 'username'));
      bloc.add(SignUpEventEmailChanged(email: 'email'));
      bloc.add(SignUpEventReset());
    },
    expect: () => [
      const SignUpState(username: 'username'),
      const SignUpState(username: 'username', email: 'email'),
      const SignUpState(),
    ],
  );
}
