import 'package:bloc_test/bloc_test.dart';
import 'package:fiszkomaniak/core/auth/auth_bloc.dart';
import 'package:fiszkomaniak/core/auth/auth_exception_model.dart';
import 'package:fiszkomaniak/interfaces/auth_interface.dart';
import 'package:fiszkomaniak/interfaces/settings_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthInterface extends Mock implements AuthInterface {}

class MockSettingsInterface extends Mock implements SettingsInterface {}

void main() {
  final AuthInterface authInterface = MockAuthInterface();
  final SettingsInterface settingsInterface = MockSettingsInterface();
  late AuthBloc bloc;

  setUp(() {
    bloc = AuthBloc(
      authInterface: authInterface,
      settingsInterface: settingsInterface,
    );
  });

  tearDown(() {
    reset(authInterface);
  });

  blocTest(
    'logged user status changed, user is logged',
    build: () => bloc,
    act: (_) => bloc.add(AuthEventLoggedUserStatusChanged(isLoggedUser: true)),
    expect: () => [AuthStateSignedIn()],
  );

  blocTest(
    'logged user status changed, user is not logged',
    build: () => bloc,
    act: (_) => bloc.add(AuthEventLoggedUserStatusChanged(isLoggedUser: false)),
    expect: () => [AuthStateSignedOut()],
  );

  blocTest(
    'sign in, success',
    build: () => bloc,
    setUp: () {
      when(() => authInterface.signIn(email: 'email', password: 'password'))
          .thenAnswer((_) async => '');
    },
    act: (_) => bloc.add(AuthEventSignIn(email: 'email', password: 'password')),
    expect: () => [
      AuthStateLoading(),
      AuthStateSignedIn(),
    ],
  );

  blocTest(
    'sign in, invalid email',
    build: () => bloc,
    setUp: () {
      when(
        () => authInterface.signIn(email: 'email', password: 'password'),
      ).thenThrow(const AuthException(code: AuthErrorCode.invalidEmail));
    },
    act: (_) => bloc.add(AuthEventSignIn(email: 'email', password: 'password')),
    expect: () => [
      AuthStateLoading(),
      AuthStateInvalidEmail(),
    ],
  );

  blocTest(
    'sign in, wrong password',
    build: () => bloc,
    setUp: () {
      when(
        () => authInterface.signIn(email: 'email', password: 'password'),
      ).thenThrow(const AuthException(code: AuthErrorCode.wrongPassword));
    },
    act: (_) => bloc.add(AuthEventSignIn(email: 'email', password: 'password')),
    expect: () => [
      AuthStateLoading(),
      AuthStateWrongPassword(),
    ],
  );

  blocTest(
    'sign in, user not found',
    build: () => bloc,
    setUp: () {
      when(
        () => authInterface.signIn(email: 'email', password: 'password'),
      ).thenThrow(const AuthException(code: AuthErrorCode.userNotFound));
    },
    act: (_) => bloc.add(AuthEventSignIn(email: 'email', password: 'password')),
    expect: () => [
      AuthStateLoading(),
      AuthStateUserNotFound(),
    ],
  );

  blocTest(
    'sign in, unknown error',
    build: () => bloc,
    setUp: () {
      when(
        () => authInterface.signIn(email: 'email', password: 'password'),
      ).thenThrow('Error...');
    },
    act: (_) => bloc.add(AuthEventSignIn(email: 'email', password: 'password')),
    expect: () => [
      AuthStateLoading(),
      const AuthStateError(message: 'Error...'),
    ],
  );

  blocTest(
    'sign up, success',
    build: () => bloc,
    setUp: () {
      when(
        () => authInterface.signUp(
          username: 'username',
          email: 'email',
          password: 'password',
        ),
      ).thenAnswer((_) async => '');
      when(() => settingsInterface.setDefaultUserSettings())
          .thenAnswer((_) async => '');
    },
    act: (_) => bloc.add(AuthEventSignUp(
      username: 'username',
      email: 'email',
      password: 'password',
    )),
    expect: () => [
      AuthStateLoading(),
      AuthStateSignedIn(),
    ],
  );

  blocTest(
    'sign up, email already in use',
    build: () => bloc,
    setUp: () {
      when(
        () => authInterface.signUp(
          username: 'username',
          email: 'email',
          password: 'password',
        ),
      ).thenThrow(const AuthException(code: AuthErrorCode.emailAlreadyInUse));
      when(() => settingsInterface.setDefaultUserSettings())
          .thenAnswer((_) async => '');
    },
    act: (_) => bloc.add(AuthEventSignUp(
      username: 'username',
      email: 'email',
      password: 'password',
    )),
    expect: () => [
      AuthStateLoading(),
      AuthStateEmailAlreadyInUse(),
    ],
  );

  blocTest(
    'sign up, unknown error',
    build: () => bloc,
    setUp: () {
      when(
        () => authInterface.signUp(
          username: 'username',
          email: 'email',
          password: 'password',
        ),
      ).thenThrow('Error...');
      when(() => settingsInterface.setDefaultUserSettings())
          .thenAnswer((_) async => '');
    },
    act: (_) => bloc.add(AuthEventSignUp(
      username: 'username',
      email: 'email',
      password: 'password',
    )),
    expect: () => [
      AuthStateLoading(),
      const AuthStateError(message: 'Error...'),
    ],
  );

  blocTest(
    'send password reset email, success',
    build: () => bloc,
    setUp: () {
      when(() => authInterface.sendPasswordResetEmail('email'))
          .thenAnswer((_) async => '');
    },
    act: (_) => bloc.add(AuthEventSendPasswordResetEmail(email: 'email')),
    expect: () => [
      AuthStateLoading(),
      AuthStatePasswordResetEmailSent(),
    ],
  );

  blocTest(
    'send password reset email, user not found',
    build: () => bloc,
    setUp: () {
      when(() => authInterface.sendPasswordResetEmail('email'))
          .thenThrow(const AuthException(code: AuthErrorCode.userNotFound));
    },
    act: (_) => bloc.add(AuthEventSendPasswordResetEmail(email: 'email')),
    expect: () => [
      AuthStateLoading(),
      AuthStateUserNotFound(),
    ],
  );

  blocTest(
    'send password reset email, invalid email',
    build: () => bloc,
    setUp: () {
      when(() => authInterface.sendPasswordResetEmail('email'))
          .thenThrow(const AuthException(code: AuthErrorCode.invalidEmail));
    },
    act: (_) => bloc.add(AuthEventSendPasswordResetEmail(email: 'email')),
    expect: () => [
      AuthStateLoading(),
      AuthStateInvalidEmail(),
    ],
  );

  blocTest(
    'send password reset email, unknown error',
    build: () => bloc,
    setUp: () {
      when(() => authInterface.sendPasswordResetEmail('email'))
          .thenThrow('Error...');
    },
    act: (_) => bloc.add(AuthEventSendPasswordResetEmail(email: 'email')),
    expect: () => [
      AuthStateLoading(),
      const AuthStateError(message: 'Error...'),
    ],
  );

  blocTest(
    'change password, success',
    build: () => bloc,
    setUp: () {
      when(
        () => authInterface.changePassword(
          currentPassword: 'currentPassword',
          newPassword: 'newPassword',
        ),
      ).thenAnswer((_) async => '');
    },
    act: (_) => bloc.add(AuthEventChangePassword(
      currentPassword: 'currentPassword',
      newPassword: 'newPassword',
    )),
    expect: () => [
      AuthStateLoading(),
      AuthStatePasswordChanged(),
    ],
  );

  blocTest(
    'change password, wrong current password',
    build: () => bloc,
    setUp: () {
      when(
        () => authInterface.changePassword(
          currentPassword: 'currentPassword',
          newPassword: 'newPassword',
        ),
      ).thenThrow(const AuthException(code: AuthErrorCode.wrongPassword));
    },
    act: (_) => bloc.add(AuthEventChangePassword(
      currentPassword: 'currentPassword',
      newPassword: 'newPassword',
    )),
    expect: () => [
      AuthStateLoading(),
      AuthStateWrongPassword(),
    ],
  );

  blocTest(
    'change password, unknown exception',
    build: () => bloc,
    setUp: () {
      when(
        () => authInterface.changePassword(
          currentPassword: 'currentPassword',
          newPassword: 'newPassword',
        ),
      ).thenThrow('Error...');
    },
    act: (_) => bloc.add(AuthEventChangePassword(
      currentPassword: 'currentPassword',
      newPassword: 'newPassword',
    )),
    expect: () => [
      AuthStateLoading(),
      const AuthStateError(message: 'Error...'),
    ],
  );

  blocTest(
    'remove logged user, success',
    build: () => bloc,
    setUp: () {
      when(() => authInterface.removeLoggedUser(password: 'password'))
          .thenAnswer((_) async => '');
    },
    act: (_) => bloc.add(AuthEventRemoveLoggedUser(password: 'password')),
    expect: () => [
      AuthStateLoading(),
    ],
    verify: (_) {
      verify(() => authInterface.removeLoggedUser(password: 'password'))
          .called(1);
    },
  );

  blocTest(
    'remove logged user, wrong password',
    build: () => bloc,
    setUp: () {
      when(() => authInterface.removeLoggedUser(password: 'password'))
          .thenThrow(const AuthException(code: AuthErrorCode.wrongPassword));
    },
    act: (_) => bloc.add(AuthEventRemoveLoggedUser(password: 'password')),
    expect: () => [
      AuthStateLoading(),
      AuthStateWrongPassword(),
    ],
    verify: (_) {
      verify(() => authInterface.removeLoggedUser(password: 'password'))
          .called(1);
    },
  );

  blocTest(
    'remove logged user, unknown error',
    build: () => bloc,
    setUp: () {
      when(() => authInterface.removeLoggedUser(password: 'password'))
          .thenThrow('Error...');
    },
    act: (_) => bloc.add(AuthEventRemoveLoggedUser(password: 'password')),
    expect: () => [
      AuthStateLoading(),
      const AuthStateError(message: 'Error...'),
    ],
    verify: (_) {
      verify(() => authInterface.removeLoggedUser(password: 'password'))
          .called(1);
    },
  );

  blocTest(
    'sign out, success',
    build: () => bloc,
    setUp: () {
      when(() => authInterface.signOut()).thenAnswer((_) async => '');
    },
    act: (_) => bloc.add(AuthEventSignOut()),
    expect: () => [AuthStateLoading()],
    verify: (_) {
      verify(() => authInterface.signOut()).called(1);
    },
  );

  blocTest(
    'sign out, error',
    build: () => bloc,
    setUp: () {
      when(() => authInterface.signOut()).thenThrow('Error...');
    },
    act: (_) => bloc.add(AuthEventSignOut()),
    expect: () => [
      AuthStateLoading(),
      const AuthStateError(message: 'Error...'),
    ],
    verify: (_) {
      verify(() => authInterface.signOut()).called(1);
    },
  );
}
