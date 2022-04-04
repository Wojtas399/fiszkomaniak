import 'package:fiszkomaniak/core/auth/auth_bloc.dart';
import 'package:fiszkomaniak/interfaces/auth_interface.dart';
import 'package:fiszkomaniak/interfaces/settings_interface.dart';
import 'package:fiszkomaniak/models/sign_in_model.dart';
import 'package:fiszkomaniak/models/sign_up_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthInterface extends Mock implements AuthInterface {}

class MockSettingsInterface extends Mock implements SettingsInterface {}

void main() {
  final AuthInterface authInterface = MockAuthInterface();
  final SettingsInterface settingsInterface = MockSettingsInterface();
  late AuthBloc authBloc;

  setUp(() {
    authBloc = AuthBloc(
      authInterface: authInterface,
      settingsInterface: settingsInterface,
    );
  });

  tearDown(() {
    reset(authInterface);
  });

  test('sign in, success', () async {
    const SignInModel data = SignInModel(
      email: 'email@example.com',
      password: 'password123',
    );
    when(() => authInterface.signIn(data)).thenAnswer((_) async => '');

    await authBloc.signIn(data);

    verify(() => authInterface.signIn(data)).called(1);
  });

  test('sign in, failure', () async {
    const SignInModel data = SignInModel(
      email: 'email@example.com',
      password: 'password123',
    );
    when(() => authInterface.signIn(data)).thenThrow('Error..');

    try {
      await authBloc.signIn(data);
    } catch (error) {
      verify(() => authInterface.signIn(data)).called(1);
      expect(error, 'Error...');
    }
  });

  test('sign up, success', () async {
    const SignUpModel data = SignUpModel(
      username: 'username',
      email: 'email@example.com',
      password: 'password123',
    );
    when(() => authInterface.signUp(data)).thenAnswer((_) async => '');

    await authBloc.signUp(data);

    verify(() => authInterface.signUp(data)).called(1);
    verify(() => settingsInterface.setDefaultSettings()).called(1);
  });

  test('sign up, failure', () async {
    const SignUpModel data = SignUpModel(
      username: 'username',
      email: 'email@example.com',
      password: 'password123',
    );
    when(() => authInterface.signUp(data)).thenThrow('Error...');

    try {
      await authBloc.signUp(data);
    } catch (error) {
      verify(() => authInterface.signUp(data)).called(1);
      verifyNever(() => settingsInterface.setDefaultSettings());
      expect(error, 'Error...');
    }
  });

  test('send password reset email, success', () async {
    const String email = 'email@example.com';
    when(() => authInterface.sendPasswordResetEmail(email))
        .thenAnswer((_) async => '');

    await authBloc.sendPasswordResetEmail(email);

    verify(() => authInterface.sendPasswordResetEmail(email)).called(1);
  });

  test('send password reset email, failure', () async {
    const String email = 'email@example.com';
    when(() => authInterface.sendPasswordResetEmail(email))
        .thenThrow('Error...');

    try {
      await authBloc.sendPasswordResetEmail(email);
    } catch (error) {
      verify(() => authInterface.sendPasswordResetEmail(email)).called(1);
      expect(error, 'Error...');
    }
  });
}
