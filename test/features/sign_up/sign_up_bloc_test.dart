import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fiszkomaniak/domain/use_cases/auth/sign_up_use_case.dart';
import 'package:fiszkomaniak/exceptions/auth_exceptions.dart';
import 'package:fiszkomaniak/features/sign_up/bloc/sign_up_bloc.dart';
import 'package:fiszkomaniak/models/bloc_status.dart';
import 'package:fiszkomaniak/validators/email_validator.dart';
import 'package:fiszkomaniak/validators/password_validator.dart';
import 'package:fiszkomaniak/validators/username_validator.dart';

class MockSignUpUseCase extends Mock implements SignUpUseCase {}

class MockUsernameValidator extends Mock implements UsernameValidator {}

class MockEmailValidator extends Mock implements EmailValidator {}

class MockPasswordValidator extends Mock implements PasswordValidator {}

void main() {
  final signUpUseCase = MockSignUpUseCase();
  final usernameValidator = MockUsernameValidator();
  final emailValidator = MockEmailValidator();
  final passwordValidator = MockPasswordValidator();

  SignUpBloc createBloc({
    String username = '',
    String email = '',
    String password = '',
    String passwordConfirmation = '',
  }) {
    return SignUpBloc(
      signUpUseCase: signUpUseCase,
      usernameValidator: usernameValidator,
      emailValidator: emailValidator,
      passwordValidator: passwordValidator,
      username: username,
      email: email,
      password: password,
      passwordConfirmation: passwordConfirmation,
    );
  }

  SignUpState createState({
    BlocStatus status = const BlocStatusInProgress(),
    String username = '',
    String email = '',
    String password = '',
    String passwordConfirmation = '',
  }) {
    return SignUpState(
      usernameValidator: usernameValidator,
      emailValidator: emailValidator,
      passwordValidator: passwordValidator,
      status: status,
      username: username,
      email: email,
      password: password,
      passwordConfirmation: passwordConfirmation,
    );
  }

  tearDown(() {
    reset(signUpUseCase);
    reset(usernameValidator);
    reset(emailValidator);
    reset(passwordValidator);
  });

  blocTest(
    'username changed, should update username in state',
    build: () => createBloc(),
    act: (SignUpBloc bloc) {
      bloc.add(
        SignUpEventUsernameChanged(username: 'username'),
      );
    },
    expect: () => [
      createState(username: 'username'),
    ],
  );

  blocTest(
    'email changed, should update email in state',
    build: () => createBloc(),
    act: (SignUpBloc bloc) {
      bloc.add(
        SignUpEventEmailChanged(email: 'email'),
      );
    },
    expect: () => [
      createState(email: 'email'),
    ],
  );

  blocTest(
    'password changed, should update password in state',
    build: () => createBloc(),
    act: (SignUpBloc bloc) {
      bloc.add(
        SignUpEventPasswordChanged(password: 'password'),
      );
    },
    expect: () => [
      createState(password: 'password'),
    ],
  );

  blocTest(
    'password confirmation changed, should update password confirmation in state',
    build: () => createBloc(),
    act: (SignUpBloc bloc) {
      bloc.add(
        SignUpEventPasswordConfirmationChanged(
          passwordConfirmation: 'passwordConfirmation',
        ),
      );
    },
    expect: () => [
      createState(passwordConfirmation: 'passwordConfirmation'),
    ],
  );

  group(
    'submit',
    () {
      setUp(() {
        when(
          () => signUpUseCase.execute(
            username: 'username',
            email: 'email',
            password: 'password',
          ),
        ).thenAnswer((_) async => '');
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

      blocTest(
        'submit, should call use case responsible for signing up user',
        build: () => createBloc(
          username: 'username',
          email: 'email',
          password: 'password',
          passwordConfirmation: 'password',
        ),
        act: (SignUpBloc bloc) {
          bloc.add(SignUpEventSubmit());
        },
        expect: () => [
          createState(
            status: const BlocStatusLoading(),
            username: 'username',
            email: 'email',
            password: 'password',
            passwordConfirmation: 'password',
          ),
          createState(
            status: const BlocStatusComplete<SignUpInfoType>(
              info: SignUpInfoType.userHasBeenSignedUp,
            ),
            username: 'username',
            email: 'email',
            password: 'password',
            passwordConfirmation: 'password',
          ),
        ],
        verify: (_) {
          verify(
            () => signUpUseCase.execute(
              username: 'username',
              email: 'email',
              password: 'password',
            ),
          ).called(1);
        },
      );

      blocTest(
        'submit, should not call use case responsible for signing up user if username is not valid',
        build: () => createBloc(
          username: 'username',
          email: 'email',
          password: 'password',
          passwordConfirmation: 'password',
        ),
        setUp: () {
          when(
            () => usernameValidator.isValid('username'),
          ).thenReturn(false);
        },
        act: (SignUpBloc bloc) {
          bloc.add(SignUpEventSubmit());
        },
        expect: () => [],
        verify: (_) {
          verifyNever(
            () => signUpUseCase.execute(
              username: 'username',
              email: 'email',
              password: 'password',
            ),
          );
        },
      );

      blocTest(
        'submit, should not call use case responsible for signing up user if email is not valid',
        build: () => createBloc(
          username: 'username',
          email: 'email',
          password: 'password',
          passwordConfirmation: 'password',
        ),
        setUp: () {
          when(
            () => emailValidator.isValid('email'),
          ).thenReturn(false);
        },
        act: (SignUpBloc bloc) {
          bloc.add(SignUpEventSubmit());
        },
        expect: () => [],
        verify: (_) {
          verifyNever(
            () => signUpUseCase.execute(
              username: 'username',
              email: 'email',
              password: 'password',
            ),
          );
        },
      );

      blocTest(
        'submit, should not call use case responsible for signing up user if password is not valid',
        build: () => createBloc(
          username: 'username',
          email: 'email',
          password: 'password',
          passwordConfirmation: 'password',
        ),
        setUp: () {
          when(
            () => passwordValidator.isValid('password'),
          ).thenReturn(false);
        },
        act: (SignUpBloc bloc) {
          bloc.add(SignUpEventSubmit());
        },
        expect: () => [],
        verify: (_) {
          verifyNever(
            () => signUpUseCase.execute(
              username: 'username',
              email: 'email',
              password: 'password',
            ),
          );
        },
      );

      blocTest(
        'submit, should not call use case responsible for signing up user if passwords are not the same',
        build: () => createBloc(
          username: 'username',
          email: 'email',
          password: 'password',
          passwordConfirmation: 'password123',
        ),
        act: (SignUpBloc bloc) {
          bloc.add(SignUpEventSubmit());
        },
        expect: () => [],
        verify: (_) {
          verifyNever(
            () => signUpUseCase.execute(
              username: 'username',
              email: 'email',
              password: 'password',
            ),
          );
        },
      );

      blocTest(
        'submit, should emit appropriate info if use case throws emailAlreadyInUse exception',
        build: () => createBloc(
          username: 'username',
          email: 'email',
          password: 'password',
          passwordConfirmation: 'password',
        ),
        setUp: () {
          when(
            () => signUpUseCase.execute(
              username: 'username',
              email: 'email',
              password: 'password',
            ),
          ).thenThrow(AuthException.emailAlreadyInUse);
        },
        act: (SignUpBloc bloc) {
          bloc.add(SignUpEventSubmit());
        },
        expect: () => [
          createState(
            status: const BlocStatusLoading(),
            username: 'username',
            email: 'email',
            password: 'password',
            passwordConfirmation: 'password',
          ),
          createState(
            status: const BlocStatusError<SignUpErrorType>(
              error: SignUpErrorType.emailAlreadyInUse,
            ),
            username: 'username',
            email: 'email',
            password: 'password',
            passwordConfirmation: 'password',
          ),
        ],
        verify: (_) {
          verify(
            () => signUpUseCase.execute(
              username: 'username',
              email: 'email',
              password: 'password',
            ),
          ).called(1);
        },
      );
    },
  );

  blocTest(
    'reset, should set username, email, password and password confirmation as empty string',
    build: () => createBloc(
      username: 'username',
      email: 'email',
      password: 'password',
      passwordConfirmation: 'password',
    ),
    act: (SignUpBloc bloc) {
      bloc.add(SignUpEventReset());
    },
    expect: () => [
      createState(
        username: '',
        email: '',
        password: '',
        passwordConfirmation: '',
      ),
    ],
  );
}
