import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:fiszkomaniak/core/auth/auth_exception_model.dart';
import 'package:fiszkomaniak/interfaces/achievements_interface.dart';
import 'package:fiszkomaniak/interfaces/user_interface.dart';
import 'package:fiszkomaniak/repositories/auth_repository.dart';
import 'package:fiszkomaniak/firebase/services/fire_auth_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFireAuthService extends Mock implements FireAuthService {}

class MockUserInterface extends Mock implements UserInterface {}

class MockAchievementsInterface extends Mock implements AchievementsInterface {}

void main() {
  final FireAuthService fireAuthService = MockFireAuthService();
  final UserInterface userInterface = MockUserInterface();
  final AchievementsInterface achievementsInterface =
      MockAchievementsInterface();
  FirebaseAuth auth = MockFirebaseAuth(signedIn: true);
  late AuthRepository repository;

  setUp(() {
    repository = AuthRepository(
      fireAuthService: fireAuthService,
      userInterface: userInterface,
      achievementsInterface: achievementsInterface,
    );
  });

  tearDown(() {
    reset(fireAuthService);
    reset(userInterface);
    reset(achievementsInterface);
  });

  test('is logged user status, logged user exists', () async {
    when(() => fireAuthService.getUserChangesStream()).thenAnswer(
      (_) => Stream.value(auth.currentUser),
    );

    final Stream<bool> isLoggedUser$ = repository.isLoggedUser();

    expect(await isLoggedUser$.first, true);
  });

  test('is logged user status, logged user does not exist', () async {
    auth = MockFirebaseAuth(signedIn: false);
    when(() => fireAuthService.getUserChangesStream()).thenAnswer(
      (_) => Stream.value(auth.currentUser),
    );

    final Stream<bool> isLoggedUser$ = repository.isLoggedUser();

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
      () => fireAuthService.signUp(email: 'email', password: 'password'),
    ).thenAnswer((_) async => 'userId');
    when(() => userInterface.addUser(userId: 'userId', username: 'username'))
        .thenAnswer((_) async => '');
    when(() => achievementsInterface.initializeAchievements())
        .thenAnswer((_) async => '');

    await repository.signUp(
      username: 'username',
      email: 'email',
      password: 'password',
    );

    verify(
      () => fireAuthService.signUp(email: 'email', password: 'password'),
    ).called(1);
    verify(
      () => userInterface.addUser(userId: 'userId', username: 'username'),
    ).called(1);
    verify(() => achievementsInterface.initializeAchievements()).called(1);
  });

  test('sign up, email already in use', () async {
    when(
      () => fireAuthService.signUp(email: 'email', password: 'password'),
    ).thenThrow(FirebaseAuthException(code: 'email-already-in-use'));

    try {
      await repository.signUp(
        username: 'username',
        email: 'email',
        password: 'password',
      );
    } catch (error) {
      verify(
        () => fireAuthService.signUp(email: 'email', password: 'password'),
      ).called(1);
      verifyNever(
        () => userInterface.addUser(
          userId: any(named: 'userId'),
          username: any(named: 'username'),
        ),
      );
      verifyNever(() => achievementsInterface.initializeAchievements());
      expect(
        error,
        const AuthException(code: AuthErrorCode.emailAlreadyInUse),
      );
    }
  });

  test('sign up, unknown firebase exception', () async {
    when(
      () => fireAuthService.signUp(email: 'email', password: 'password'),
    ).thenThrow(FirebaseAuthException(code: 'unknown-error'));

    try {
      await repository.signUp(
        username: 'username',
        email: 'email',
        password: 'password',
      );
    } catch (error) {
      verify(
        () => fireAuthService.signUp(email: 'email', password: 'password'),
      ).called(1);
      verifyNever(
        () => userInterface.addUser(
          userId: any(named: 'userId'),
          username: any(named: 'username'),
        ),
      );
      verifyNever(() => achievementsInterface.initializeAchievements());
      expect(error, FirebaseAuthException(code: 'unknown-error'));
    }
  });

  test('sign up, unknown exception', () async {
    when(
      () => fireAuthService.signUp(email: 'email', password: 'password'),
    ).thenThrow('Error...');

    try {
      await repository.signUp(
        username: 'username',
        email: 'email',
        password: 'password',
      );
    } catch (error) {
      verify(
        () => fireAuthService.signUp(email: 'email', password: 'password'),
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

  test('remove logged user, success', () async {
    when(() => fireAuthService.removeLoggedUser('password'))
        .thenAnswer((_) async => '');

    await repository.removeLoggedUser(password: 'password');

    verify(() => fireAuthService.removeLoggedUser('password')).called(1);
  });

  test('remove logged user, wrong password', () async {
    when(() => fireAuthService.removeLoggedUser('password'))
        .thenThrow(FirebaseAuthException(code: 'wrong-password'));

    try {
      await repository.removeLoggedUser(password: 'password');
    } catch (error) {
      verify(() => fireAuthService.removeLoggedUser('password')).called(1);
      expect(error, const AuthException(code: AuthErrorCode.wrongPassword));
    }
  });

  test('remove logged user, unknown error', () async {
    when(() => fireAuthService.removeLoggedUser('password'))
        .thenThrow('Error...');

    try {
      await repository.removeLoggedUser(password: 'password');
    } catch (error) {
      verify(() => fireAuthService.removeLoggedUser('password')).called(1);
      expect(error, 'Error...');
    }
  });

  test('sign out, success', () async {
    when(() => fireAuthService.signOut()).thenAnswer((_) async => '');

    await repository.signOut();

    verify(() => fireAuthService.signOut()).called(1);
  });

  test('sign out, error', () async {
    when(() => fireAuthService.signOut()).thenThrow('Error...');

    try {
      await repository.signOut();
    } catch (error) {
      verify(() => fireAuthService.signOut()).called(1);
      expect(error, 'Error...');
    }
  });
}
