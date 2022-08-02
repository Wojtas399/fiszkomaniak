import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fiszkomaniak/domain/use_cases/auth/sign_in_use_case.dart';
import 'package:fiszkomaniak/exceptions/auth_exceptions.dart';
import 'package:fiszkomaniak/features/sign_in/bloc/sign_in_bloc.dart';
import 'package:fiszkomaniak/models/bloc_status.dart';

class MockSignInUseCase extends Mock implements SignInUseCase {}

void main() {
  final signInUseCase = MockSignInUseCase();

  SignInBloc createBloc({
    String email = '',
    String password = '',
  }) {
    return SignInBloc(
      signInUseCase: signInUseCase,
      email: email,
      password: password,
    );
  }

  SignInState createState({
    BlocStatus status = const BlocStatusInProgress(),
    String email = '',
    String password = '',
  }) {
    return SignInState(
      status: status,
      email: email,
      password: password,
    );
  }

  tearDown(() {
    reset(signInUseCase);
  });

  blocTest(
    'email changed, should update email in state',
    build: () => createBloc(),
    act: (SignInBloc bloc) {
      bloc.add(SignInEventEmailChanged(email: 'email'));
    },
    expect: () => [
      createState(email: 'email'),
    ],
  );

  blocTest(
    'password changed, should update password in state',
    build: () => createBloc(),
    act: (SignInBloc bloc) {
      bloc.add(SignInEventPasswordChanged(password: 'password'));
    },
    expect: () => [
      createState(password: 'password'),
    ],
  );

  blocTest(
    'submit, should call use case responsible for signing in user',
    build: () => createBloc(
      email: 'email',
      password: 'password',
    ),
    setUp: () {
      when(
        () => signInUseCase.execute(
          email: 'email',
          password: 'password',
        ),
      ).thenAnswer((_) async => '');
    },
    act: (SignInBloc bloc) {
      bloc.add(SignInEventSubmit());
    },
    expect: () => [
      createState(
        status: const BlocStatusLoading(),
        email: 'email',
        password: 'password',
      ),
      createState(
        status: const BlocStatusComplete<SignInInfoType>(
          info: SignInInfoType.userHasBeenSignedIn,
        ),
        email: 'email',
        password: 'password',
      ),
    ],
    verify: (_) {
      verify(
        () => signInUseCase.execute(
          email: 'email',
          password: 'password',
        ),
      ).called(1);
    },
  );

  blocTest(
    'submit, should not call use case responsible for signing in user if email is empty',
    build: () => createBloc(
      email: '',
      password: 'password',
    ),
    setUp: () {
      when(
        () => signInUseCase.execute(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async => '');
    },
    act: (SignInBloc bloc) {
      bloc.add(SignInEventSubmit());
    },
    expect: () => [],
    verify: (_) {
      verifyNever(
        () => signInUseCase.execute(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      );
    },
  );

  blocTest(
    'submit, should not call use case responsible for signing in user if password is empty',
    build: () => createBloc(
      email: 'email',
      password: '',
    ),
    setUp: () {
      when(
        () => signInUseCase.execute(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async => '');
    },
    act: (SignInBloc bloc) {
      bloc.add(SignInEventSubmit());
    },
    expect: () => [],
    verify: (_) {
      verifyNever(
        () => signInUseCase.execute(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      );
    },
  );

  blocTest(
    'submit, user not found exception',
    build: () => createBloc(
      email: 'email',
      password: 'password',
    ),
    setUp: () {
      when(
        () => signInUseCase.execute(
          email: 'email',
          password: 'password',
        ),
      ).thenThrow(AuthException.userNotFound);
    },
    act: (SignInBloc bloc) {
      bloc.add(SignInEventSubmit());
    },
    expect: () => [
      createState(
        status: const BlocStatusLoading(),
        email: 'email',
        password: 'password',
      ),
      createState(
        status: const BlocStatusError<SignInErrorType>(
          errorType: SignInErrorType.userNotFound,
        ),
        email: 'email',
        password: 'password',
      ),
    ],
    verify: (_) {
      verify(
        () => signInUseCase.execute(
          email: 'email',
          password: 'password',
        ),
      ).called(1);
    },
  );

  blocTest(
    'submit, invalid email exception',
    build: () => createBloc(
      email: 'email',
      password: 'password',
    ),
    setUp: () {
      when(
        () => signInUseCase.execute(
          email: 'email',
          password: 'password',
        ),
      ).thenThrow(AuthException.invalidEmail);
    },
    act: (SignInBloc bloc) {
      bloc.add(SignInEventSubmit());
    },
    expect: () => [
      createState(
        status: const BlocStatusLoading(),
        email: 'email',
        password: 'password',
      ),
      createState(
        status: const BlocStatusError<SignInErrorType>(
          errorType: SignInErrorType.invalidEmail,
        ),
        email: 'email',
        password: 'password',
      ),
    ],
    verify: (_) {
      verify(
        () => signInUseCase.execute(
          email: 'email',
          password: 'password',
        ),
      ).called(1);
    },
  );

  blocTest(
    'submit, wrong password exception',
    build: () => createBloc(
      email: 'email',
      password: 'password',
    ),
    setUp: () {
      when(
        () => signInUseCase.execute(
          email: 'email',
          password: 'password',
        ),
      ).thenThrow(AuthException.wrongPassword);
    },
    act: (SignInBloc bloc) {
      bloc.add(SignInEventSubmit());
    },
    expect: () => [
      createState(
        status: const BlocStatusLoading(),
        email: 'email',
        password: 'password',
      ),
      createState(
        status: const BlocStatusError<SignInErrorType>(
          errorType: SignInErrorType.wrongPassword,
        ),
        email: 'email',
        password: 'password',
      ),
    ],
    verify: (_) {
      verify(
        () => signInUseCase.execute(
          email: 'email',
          password: 'password',
        ),
      ).called(1);
    },
  );

  blocTest(
    'reset, should set email and password as empty strings',
    build: () => createBloc(
      email: 'email',
      password: 'password',
    ),
    act: (SignInBloc bloc) {
      bloc.add(SignInEventReset());
    },
    expect: () => [
      createState(
        email: '',
        password: '',
      ),
    ],
  );
}
