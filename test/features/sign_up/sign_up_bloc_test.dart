import 'package:bloc_test/bloc_test.dart';
import 'package:fiszkomaniak/core/auth/auth_bloc.dart';
import 'package:fiszkomaniak/features/sign_up/bloc/sign_up_bloc.dart';
import 'package:fiszkomaniak/features/sign_up/bloc/sign_up_event.dart';
import 'package:fiszkomaniak/features/sign_up/bloc/sign_up_state.dart';
import 'package:fiszkomaniak/models/http_status_model.dart';
import 'package:fiszkomaniak/models/sign_up_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthBloc extends Mock implements AuthBloc {}

void main() {
  final AuthBloc authBloc = MockAuthBloc();
  late SignUpBloc signUpBloc;
  const SignUpModel data = SignUpModel(
    username: 'username',
    email: 'email@example.com',
    password: 'password123',
  );

  setUp(() {
    signUpBloc = SignUpBloc(authBloc: authBloc);
  });

  tearDown(() {
    reset(authBloc);
  });

  test('initial state', () {
    final SignUpState state = signUpBloc.state;
    expect(state.username, '');
    expect(state.email, '');
    expect(state.password, '');
    expect(state.passwordConfirmation, '');
    expect(state.hasUsernameBeenEdited, false);
    expect(state.hasEmailBeenEdited, false);
    expect(state.hasPasswordBeenEdited, false);
    expect(state.hasPasswordConfirmationBeenEdited, false);
    expect(state.isCorrectUsername, false);
    expect(state.isCorrectEmail, false);
    expect(state.isCorrectPassword, false);
    expect(state.isCorrectPasswordConfirmation, true);
    expect(state.isDisabledButton, true);
    expect(state.httpStatus, const HttpStatusInitial());
  });

  blocTest(
    'username changed, correct',
    build: () => signUpBloc,
    act: (SignUpBloc bloc) =>
        bloc.add(SignUpEventUsernameChanged(username: data.username)),
    expect: () => [
      SignUpState(username: data.username, hasUsernameBeenEdited: true),
    ],
    verify: (SignUpBloc bloc) => expect(bloc.state.isCorrectUsername, true),
  );

  blocTest(
    'username changed, incorrect',
    build: () => signUpBloc,
    act: (SignUpBloc bloc) =>
        bloc.add(SignUpEventUsernameChanged(username: 'use')),
    expect: () => [
      const SignUpState(username: 'use', hasUsernameBeenEdited: true),
    ],
    verify: (SignUpBloc bloc) => expect(bloc.state.isCorrectUsername, false),
  );

  blocTest(
    'email changed, correct',
    build: () => signUpBloc,
    act: (SignUpBloc bloc) =>
        bloc.add(SignUpEventEmailChanged(email: data.email)),
    expect: () => [SignUpState(email: data.email, hasEmailBeenEdited: true)],
    verify: (SignUpBloc bloc) => expect(bloc.state.isCorrectEmail, true),
  );

  blocTest(
    'email changed, incorrect',
    build: () => signUpBloc,
    act: (SignUpBloc bloc) =>
        bloc.add(SignUpEventEmailChanged(email: 'email@exa')),
    expect: () => [
      const SignUpState(email: 'email@exa', hasEmailBeenEdited: true),
    ],
    verify: (SignUpBloc bloc) => expect(bloc.state.isCorrectEmail, false),
  );

  blocTest(
    'password changed, correct',
    build: () => signUpBloc,
    act: (SignUpBloc bloc) =>
        bloc.add(SignUpEventPasswordChanged(password: data.password)),
    expect: () => [
      SignUpState(password: data.password, hasPasswordBeenEdited: true),
    ],
    verify: (SignUpBloc bloc) => expect(bloc.state.isCorrectPassword, true),
  );

  blocTest(
    'password changed, incorrect',
    build: () => signUpBloc,
    act: (SignUpBloc bloc) =>
        bloc.add(SignUpEventPasswordChanged(password: 'passw')),
    expect: () => [
      const SignUpState(password: 'passw', hasPasswordBeenEdited: true),
    ],
    verify: (SignUpBloc bloc) => expect(bloc.state.isCorrectPassword, false),
  );

  blocTest(
    'password confirmation changed, correct',
    build: () => signUpBloc,
    act: (SignUpBloc bloc) {
      bloc.add(SignUpEventPasswordChanged(password: data.password));
      bloc.add(SignUpEventPasswordConfirmationChanged(
        passwordConfirmation: data.password,
      ));
    },
    expect: () => [
      SignUpState(
        password: data.password,
        hasPasswordBeenEdited: true,
      ),
      SignUpState(
        password: data.password,
        passwordConfirmation: data.password,
        hasPasswordBeenEdited: true,
        hasPasswordConfirmationBeenEdited: true,
      )
    ],
    verify: (SignUpBloc bloc) => expect(
      bloc.state.isCorrectPasswordConfirmation,
      true,
    ),
  );

  blocTest(
    'password confirmation changed, incorrect',
    build: () => signUpBloc,
    act: (SignUpBloc bloc) {
      bloc.add(SignUpEventPasswordChanged(password: data.password));
      bloc.add(SignUpEventPasswordConfirmationChanged(
        passwordConfirmation: 'passwd',
      ));
    },
    expect: () => [
      SignUpState(
        password: data.password,
        hasPasswordBeenEdited: true,
      ),
      SignUpState(
        password: data.password,
        passwordConfirmation: 'passwd',
        hasPasswordBeenEdited: true,
        hasPasswordConfirmationBeenEdited: true,
      )
    ],
    verify: (SignUpBloc bloc) => expect(
      bloc.state.isCorrectPasswordConfirmation,
      false,
    ),
  );

  blocTest(
    'submit, success',
    build: () => signUpBloc,
    setUp: () {
      when(() => authBloc.signUp(data))
          .thenAnswer((_) async => HttpStatusSuccess());
    },
    act: (SignUpBloc bloc) => bloc.add(SignUpEventSubmit(
      username: data.username,
      email: data.email,
      password: data.password,
    )),
    expect: () => [
      SignUpState(httpStatus: HttpStatusSubmitting()),
      SignUpState(httpStatus: HttpStatusSuccess()),
    ],
    verify: (_) => verify(() => authBloc.signUp(data)).called(1),
  );

  blocTest(
    'submit, failure',
    build: () => signUpBloc,
    setUp: () {
      when(() => authBloc.signUp(data)).thenAnswer(
        (_) async => const HttpStatusFailure(message: 'Error...'),
      );
    },
    act: (SignUpBloc bloc) => bloc.add(SignUpEventSubmit(
      username: data.username,
      email: data.email,
      password: data.password,
    )),
    expect: () => [
      SignUpState(httpStatus: HttpStatusSubmitting()),
      const SignUpState(httpStatus: HttpStatusFailure(message: 'Error...')),
    ],
    verify: (_) => verify(() => authBloc.signUp(data)).called(1),
  );

  blocTest(
    'reset',
    build: () => signUpBloc,
    act: (SignUpBloc bloc) => bloc.add(SignUpEventReset()),
    expect: () => [const SignUpState()],
  );
}
