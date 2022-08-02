import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fiszkomaniak/domain/repositories/auth_repository.dart';
import 'package:fiszkomaniak/exceptions/auth_exceptions.dart';
import 'package:fiszkomaniak/firebase/services/fire_auth_service.dart';

class MockFireAuthService extends Mock implements FireAuthService {}

void main() {
  final fireAuthService = MockFireAuthService();
  late AuthRepository repository;

  setUp(() {
    repository = AuthRepository(fireAuthService: fireAuthService);
  });

  tearDown(() {
    reset(fireAuthService);
  });

  test(
    'is user logged, should return stream with true if user is logged',
    () async {
      when(
        () => fireAuthService.isUserLogged(),
      ).thenAnswer((_) => Stream.value(true));

      final Stream<bool> isUserLogged$ = repository.isUserLogged$;

      expect(await isUserLogged$.first, true);
      verify(() => fireAuthService.isUserLogged()).called(1);
    },
  );

  test(
    'is user logged, should return stream with false if user is not logged',
    () async {
      when(
        () => fireAuthService.isUserLogged(),
      ).thenAnswer((_) => Stream.value(false));

      final Stream<bool> isUserLogged$ = repository.isUserLogged$;

      expect(await isUserLogged$.first, false);
      verify(() => fireAuthService.isUserLogged()).called(1);
    },
  );

  test(
    'sign in, should call method responsible for signing in user',
    () async {
      when(
        () => fireAuthService.signIn(email: 'email', password: 'password'),
      ).thenAnswer((_) async => '');

      await repository.signIn(email: 'email', password: 'password');

      verify(
        () => fireAuthService.signIn(email: 'email', password: 'password'),
      ).called(1);
    },
  );

  test(
    'sign up, should call method responsible for signing up user',
    () async {
      when(
        () => fireAuthService.signUp(email: 'email', password: 'password'),
      ).thenAnswer((_) async => '');

      await repository.signUp(email: 'email', password: 'password');

      verify(
        () => fireAuthService.signUp(email: 'email', password: 'password'),
      ).called(1);
    },
  );

  test(
    'reauthenticate, should call method responsible for authenticating user again',
    () async {
      when(
        () => fireAuthService.reauthenticate('password'),
      ).thenAnswer((_) async => '');

      await repository.reauthenticate(password: 'password');

      verify(() => fireAuthService.reauthenticate('password')).called(1);
    },
  );

  test(
    'send password reset email, should call method responsible for sending email to reset password',
    () async {
      when(
        () => fireAuthService.sendPasswordResetEmail(email: 'email'),
      ).thenAnswer((_) async => '');

      await repository.sendPasswordResetEmail('email');

      verify(
        () => fireAuthService.sendPasswordResetEmail(email: 'email'),
      ).called(1);
    },
  );

  test(
    'update password, should call method responsible for changing password',
    () async {
      when(
        () => fireAuthService.changePassword(
          currentPassword: 'currentPassword',
          newPassword: 'newPassword',
        ),
      ).thenAnswer((_) async => '');

      await repository.updatePassword(
        currentPassword: 'currentPassword',
        newPassword: 'newPassword',
      );

      verify(
        () => fireAuthService.changePassword(
          currentPassword: 'currentPassword',
          newPassword: 'newPassword',
        ),
      ).called(1);
    },
  );

  test(
    'delete logged user, should call method responsible for deleting logged user',
    () async {
      when(
        () => fireAuthService.deleteLoggedUserAccount(),
      ).thenAnswer((_) async => '');

      await repository.deleteLoggedUserAccount();

      verify(() => fireAuthService.deleteLoggedUserAccount()).called(1);
    },
  );

  test(
    'sign out, should call method responsible for signing out user',
    () async {
      when(() => fireAuthService.signOut()).thenAnswer((_) async => '');

      await repository.signOut();

      verify(() => fireAuthService.signOut()).called(1);
    },
  );

  test(
    'firebase auth exception user not found',
    () async {
      when(() => fireAuthService.reauthenticate('password')).thenThrow(
        FirebaseAuthException(code: 'user-not-found'),
      );

      try {
        await repository.reauthenticate(password: 'password');
      } catch (error) {
        expect(error, AuthException.userNotFound);
      }
    },
  );

  test(
    'firebase auth exception wrong password',
    () async {
      when(() => fireAuthService.reauthenticate('password')).thenThrow(
        FirebaseAuthException(code: 'wrong-password'),
      );

      try {
        await repository.reauthenticate(password: 'password');
      } catch (error) {
        expect(error, AuthException.wrongPassword);
      }
    },
  );

  test(
    'firebase auth exception invalid email',
    () async {
      when(() => fireAuthService.reauthenticate('password')).thenThrow(
        FirebaseAuthException(code: 'invalid-email'),
      );

      try {
        await repository.reauthenticate(password: 'password');
      } catch (error) {
        expect(error, AuthException.invalidEmail);
      }
    },
  );

  test(
    'firebase auth exception email already in use',
    () async {
      when(() => fireAuthService.reauthenticate('password')).thenThrow(
        FirebaseAuthException(code: 'email-already-in-use'),
      );

      try {
        await repository.reauthenticate(password: 'password');
      } catch (error) {
        expect(error, AuthException.emailAlreadyInUse);
      }
    },
  );
}
