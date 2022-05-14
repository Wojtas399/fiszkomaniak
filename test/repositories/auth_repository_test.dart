import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:fiszkomaniak/core/auth/auth_exception_model.dart';
import 'package:fiszkomaniak/repositories/auth_repository.dart';
import 'package:fiszkomaniak/firebase/services/fire_auth_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFireAuthService extends Mock implements FireAuthService {}

void main() {
  final FireAuthService fireAuthService = MockFireAuthService();
  FirebaseAuth auth = MockFirebaseAuth(signedIn: true);
  late AuthRepository repository;

  setUp(() {
    repository = AuthRepository(fireAuthService: fireAuthService);
  });

  tearDown(() {
    reset(fireAuthService);
  });

  test('is logged user status, logged user exists', () async {
    when(() => fireAuthService.getUserChangesStream()).thenAnswer(
      (_) => Stream.value(auth.currentUser),
    );

    final Stream<bool> isLoggedUser$ = repository.isLoggedUserStatus();

    expect(await isLoggedUser$.first, true);
  });

  test('is logged user status, logged user does not exist', () async {
    auth = MockFirebaseAuth(signedIn: false);
    when(() => fireAuthService.getUserChangesStream()).thenAnswer(
      (_) => Stream.value(auth.currentUser),
    );

    final Stream<bool> isLoggedUser$ = repository.isLoggedUserStatus();

    expect(await isLoggedUser$.first, false);
  });

  test('sign in, success', () async {
    when(() => fireAuthService.signIn(email: 'email', password: 'password'))
        .thenAnswer((_) async => '');

    await repository.signIn(email: 'email', password: 'password');

    verify(() => fireAuthService.signIn(email: 'email', password: 'password'))
        .called(1);
  });

  test('sign in, user not found', () async {
    when(() => fireAuthService.signIn(email: 'email', password: 'password'))
        .thenThrow(FirebaseAuthException(code: 'user-not-found'));

    try {
      await repository.signIn(email: 'email', password: 'password');
    } catch (error) {
      verify(() => fireAuthService.signIn(email: 'email', password: 'password'))
          .called(1);
      expect(error, const AuthException(code: AuthErrorCode.userNotFound));
    }
  });

  test('sign in, wrong password', () async {
    when(() => fireAuthService.signIn(email: 'email', password: 'password'))
        .thenThrow(FirebaseAuthException(code: 'wrong-password'));

    try {
      await repository.signIn(email: 'email', password: 'password');
    } catch (error) {
      verify(() => fireAuthService.signIn(email: 'email', password: 'password'))
          .called(1);
      expect(error, const AuthException(code: AuthErrorCode.wrongPassword));
    }
  });

  test('sign in, invalid email', () async {
    when(() => fireAuthService.signIn(email: 'email', password: 'password'))
        .thenThrow(FirebaseAuthException(code: 'invalid-email'));

    try {
      await repository.signIn(email: 'email', password: 'password');
    } catch (error) {
      verify(() => fireAuthService.signIn(email: 'email', password: 'password'))
          .called(1);
      expect(error, const AuthException(code: AuthErrorCode.invalidEmail));
    }
  });

  test('sign in, unknown firebase auth exception', () async {
    when(() => fireAuthService.signIn(email: 'email', password: 'password'))
        .thenThrow(FirebaseAuthException(code: 'unknown-error'));

    try {
      await repository.signIn(email: 'email', password: 'password');
    } catch (error) {
      verify(() => fireAuthService.signIn(email: 'email', password: 'password'))
          .called(1);
      expect(error, FirebaseAuthException(code: 'unknown-error'));
    }
  });

  test('sign in, unknown exception', () async {
    when(() => fireAuthService.signIn(email: 'email', password: 'password'))
        .thenThrow('Error...');

    try {
      await repository.signIn(email: 'email', password: 'password');
    } catch (error) {
      verify(() => fireAuthService.signIn(email: 'email', password: 'password'))
          .called(1);
      expect(error, 'Error...');
    }
  });

  test('sign up, success', () async {
    when(
      () => fireAuthService.signUp(
        username: 'username',
        email: 'email',
        password: 'password',
      ),
    ).thenAnswer((_) async => '');

    await repository.signUp(
      username: 'username',
      email: 'email',
      password: 'password',
    );

    verify(
      () => fireAuthService.signUp(
        username: 'username',
        email: 'email',
        password: 'password',
      ),
    ).called(1);
  });

  test('sign up, email already in use', () async {
    when(
      () => fireAuthService.signUp(
        username: 'username',
        email: 'email',
        password: 'password',
      ),
    ).thenThrow(FirebaseAuthException(code: 'email-already-in-use'));

    try {
      await repository.signUp(
        username: 'username',
        email: 'email',
        password: 'password',
      );
    } catch (error) {
      verify(
        () => fireAuthService.signUp(
          username: 'username',
          email: 'email',
          password: 'password',
        ),
      ).called(1);
      expect(
        error,
        const AuthException(code: AuthErrorCode.emailAlreadyInUse),
      );
    }
  });

  test('sign up, unknown firebase exception', () async {
    when(
      () => fireAuthService.signUp(
        username: 'username',
        email: 'email',
        password: 'password',
      ),
    ).thenThrow(FirebaseAuthException(code: 'unknown-error'));

    try {
      await repository.signUp(
        username: 'username',
        email: 'email',
        password: 'password',
      );
    } catch (error) {
      verify(
        () => fireAuthService.signUp(
          username: 'username',
          email: 'email',
          password: 'password',
        ),
      ).called(1);
      expect(error, FirebaseAuthException(code: 'unknown-error'));
    }
  });

  test('sign up, unknown exception', () async {
    when(
      () => fireAuthService.signUp(
        username: 'username',
        email: 'email',
        password: 'password',
      ),
    ).thenThrow('Error...');

    try {
      await repository.signUp(
        username: 'username',
        email: 'email',
        password: 'password',
      );
    } catch (error) {
      verify(
        () => fireAuthService.signUp(
          username: 'username',
          email: 'email',
          password: 'password',
        ),
      ).called(1);
      expect(error, 'Error...');
    }
  });

  test('send password reset email, success', () async {
    when(() => fireAuthService.sendPasswordResetEmail(email: 'email'))
        .thenAnswer((_) async => '');

    await repository.sendPasswordResetEmail('email');

    verify(() => fireAuthService.sendPasswordResetEmail(email: 'email'))
        .called(1);
  });

  test('send password reset email, user not found', () async {
    when(() => fireAuthService.sendPasswordResetEmail(email: 'email'))
        .thenThrow(FirebaseAuthException(code: 'user-not-found'));

    try {
      await repository.sendPasswordResetEmail('email');
    } catch (error) {
      verify(() => fireAuthService.sendPasswordResetEmail(email: 'email'))
          .called(1);
      expect(error, const AuthException(code: AuthErrorCode.userNotFound));
    }
  });

  test('send password reset email, invalid email', () async {
    when(() => fireAuthService.sendPasswordResetEmail(email: 'email'))
        .thenThrow(FirebaseAuthException(code: 'invalid-email'));

    try {
      await repository.sendPasswordResetEmail('email');
    } catch (error) {
      verify(() => fireAuthService.sendPasswordResetEmail(email: 'email'))
          .called(1);
      expect(error, const AuthException(code: AuthErrorCode.invalidEmail));
    }
  });

  test('send password reset email, unknown firebase exception', () async {
    when(() => fireAuthService.sendPasswordResetEmail(email: 'email'))
        .thenThrow(FirebaseAuthException(code: 'unknown-error'));

    try {
      await repository.sendPasswordResetEmail('email');
    } catch (error) {
      verify(() => fireAuthService.sendPasswordResetEmail(email: 'email'))
          .called(1);
      expect(error, FirebaseAuthException(code: 'unknown-error'));
    }
  });

  test('send password reset email, unknown exception', () async {
    when(() => fireAuthService.sendPasswordResetEmail(email: 'email'))
        .thenThrow('Error...');

    try {
      await repository.sendPasswordResetEmail('email');
    } catch (error) {
      verify(() => fireAuthService.sendPasswordResetEmail(email: 'email'))
          .called(1);
      expect(error, 'Error...');
    }
  });

  test('change password, success', () async {
    when(
      () => fireAuthService.changePassword(
        currentPassword: 'currentPassword',
        newPassword: 'newPassword',
      ),
    ).thenAnswer((_) async => '');

    await repository.changePassword(
      currentPassword: 'currentPassword',
      newPassword: 'newPassword',
    );

    verify(
      () => fireAuthService.changePassword(
        currentPassword: 'currentPassword',
        newPassword: 'newPassword',
      ),
    ).called(1);
  });

  test('change password, wrong current password', () async {
    when(
      () => fireAuthService.changePassword(
        currentPassword: 'currentPassword',
        newPassword: 'newPassword',
      ),
    ).thenThrow(FirebaseAuthException(code: 'wrong-password'));

    try {
      await repository.changePassword(
        currentPassword: 'currentPassword',
        newPassword: 'newPassword',
      );
    } catch (error) {
      verify(
        () => fireAuthService.changePassword(
          currentPassword: 'currentPassword',
          newPassword: 'newPassword',
        ),
      ).called(1);
      expect(error, const AuthException(code: AuthErrorCode.wrongPassword));
    }
  });

  test('change password, unknown firebase auth exception', () async {
    when(
      () => fireAuthService.changePassword(
        currentPassword: 'currentPassword',
        newPassword: 'newPassword',
      ),
    ).thenThrow(FirebaseAuthException(code: 'unknown-error'));

    try {
      await repository.changePassword(
        currentPassword: 'currentPassword',
        newPassword: 'newPassword',
      );
    } catch (error) {
      verify(
        () => fireAuthService.changePassword(
          currentPassword: 'currentPassword',
          newPassword: 'newPassword',
        ),
      ).called(1);
      expect(error, FirebaseAuthException(code: 'unknown-error'));
    }
  });

  test('change password, unknown exception', () async {
    when(
      () => fireAuthService.changePassword(
        currentPassword: 'currentPassword',
        newPassword: 'newPassword',
      ),
    ).thenThrow('Error...');

    try {
      await repository.changePassword(
        currentPassword: 'currentPassword',
        newPassword: 'newPassword',
      );
    } catch (error) {
      verify(
        () => fireAuthService.changePassword(
          currentPassword: 'currentPassword',
          newPassword: 'newPassword',
        ),
      ).called(1);
      expect(error, 'Error...');
    }
  });
}
