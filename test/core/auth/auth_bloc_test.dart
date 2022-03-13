import 'package:fiszkomaniak/core/auth/auth_bloc.dart';
import 'package:fiszkomaniak/core/auth/auth_subscriber.dart';
import 'package:fiszkomaniak/interfaces/auth_interface.dart';
import 'package:fiszkomaniak/models/sign_in_model.dart';
import 'package:fiszkomaniak/models/sign_up_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthInterface extends Mock implements AuthInterface {}

class MockAuthSubscriber extends Mock implements AuthSubscriber {}

void main() {
  final AuthInterface authInterface = MockAuthInterface();
  final AuthSubscriber authSubscriber = MockAuthSubscriber();
  late AuthBloc authBloc;

  setUp(() {
    authBloc = AuthBloc(
      authInterface: authInterface,
      authSubscriber: authSubscriber,
    );
  });

  tearDown(() {
    reset(authInterface);
    reset(authSubscriber);
  });

  test('initialize', () {
    authBloc.initialize();

    verify(() => authSubscriber.subscribe()).called(1);
  });

  test('sign in, success', () async {
    final SignInModel data = SignInModel(
      email: 'email@example.com',
      password: 'password123',
    );
    when(() => authInterface.signIn(data)).thenAnswer((_) async => '');

    await authBloc.signIn(data);

    verify(() => authInterface.signIn(data)).called(1);
  });

  test('sign in, failure', () async {
    final SignInModel data = SignInModel(
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
    final SignUpModel data = SignUpModel(
      username: 'username',
      email: 'email@example.com',
      password: 'password123',
    );
    when(() => authInterface.signUp(data)).thenAnswer((_) async => '');

    await authBloc.signUp(data);

    verify(() => authInterface.signUp(data)).called(1);
  });

  test('sign up, failure', () async {
    final SignUpModel data = SignUpModel(
      username: 'username',
      email: 'email@example.com',
      password: 'password123',
    );
    when(() => authInterface.signUp(data)).thenThrow('Error...');

    try {
      await authBloc.signUp(data);
    } catch (error) {
      verify(() => authInterface.signUp(data)).called(1);
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

  test('dispose', () {
    authBloc.dispose();

    verify(() => authSubscriber.unsubscribe()).called(1);
  });
}
